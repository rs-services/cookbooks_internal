#
# RightScale Tools
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

require 'fileutils'
require 'set'
require 'rightscale_tools/filesystem'

module RightScale
  module Tools
    module Platform
      class Linux < Platform
        def initialize(platform, version, options = {})
          super(platform, version, options)

          @filesystem = RightScale::Tools::FileSystem.factory
        end

        def pid_exists? (pid)
          system "kill -0 #{pid}"
          return $? == 0
        end

        def create_partition(device, first, last)
          partitions = get_device_partition_info(device)[:partitions].keys
          @logger.debug "Running command: parted --script #{device} mkpart primary #{first}B #{last}B"
          res=`parted --script #{device} mkpart primary #{first}B #{last}B`
          raise "Making primary partition failed: #{res.inspect}" unless $?.success?
          partition = Set.new(get_device_partition_info(device)[:partitions].keys) - partitions
          partition = "%s%u" % [device, partition.first]
          # I don't believe we need to wait for this, but the old code did...
          success = false
          300.times do |attempt|
            break success = true if File.blockdev? partition
            sleep 1
          end
          raise "timeout while waiting for device #{partition}" unless success
          # return the partition device
          partition
        end

        def destroy_partition(device)
          raise "device not a partition: #{device}" unless device =~ /^(\/dev\/.+)(\d+)$/
          execute("parted --script #{$1} rm #{$2}")
        end

        def get_lock_file_name(name)
          File.join('/var', 'lock', name)
        end

        def get_device_for_mount_point(mount_point)
          IO.readlines('/etc/fstab').each do |entry|
            device, device_mount_point, _, _ = entry.split /[\t\s]/
            return device if device_mount_point == mount_point
          end
          if mount(nil, nil, :return_output => true) =~ /^(.+) on #{Regexp.escape(mount_point)} type/
            return $1
          end
          nil
        end

        def set_mount_point_for_device(device, mount_point)
          FileUtils.cp('/etc/fstab', '/etc/fstab.bak')
          fstab = IO.readlines('/etc/fstab')
          File.open('/etc/fstab', 'w') do |file|
            fstab.each do |entry|
              if entry.include? mount_point
                @logger.warn "detected previous entry for #{mount_point} in /etc/fstab; removing"
              else
                file.puts entry
              end
            end

            options = ['defaults', 'noatime']
            #
            # Ubuntu systems using upstart require the 'bootwait' option, otherwise
            # upstart will try to boot without waiting for the LVM volume to be mounted.
            #
            options << 'bootwait' if @platform == "Ubuntu"

            entry = "#{device}\t#{mount_point}\t#{@filesystem.name}\t#{options.join(',')}\t0 0"
            @logger.info "adding device to /etc/fstab: #{entry}"
            file.puts entry
          end
        end

        def remove_mount_point_for_device(device)
          fstab = IO.readlines('/etc/fstab')
          File.open('/etc/fstab', 'w') do |file|
            fstab.each do |entry|
              file.puts(entry) unless entry.include? device
            end
          end
        end

        def get_current_devices
          partitions = IO.readlines('/proc/partitions').drop(2).map do |line|
            line.chomp.split.last
          end.reject do |partition|
            partition =~ /^dm-\d/
          end
          devices = partitions.select do |partition|
            partition =~ /[a-z]$/
          end.sort.map {|device| "/dev/#{device}"}
          if devices.empty?
            devices = partitions.select do |partition|
              partition =~ /[0-9]$/
            end.sort.map {|device| "/dev/#{device}"}
          end
          devices
        end

        def get_device_type
          get_current_devices.first =~ /^\/dev\/([a-z]+d)[a-z]+\d?/
          device_type = $1
          if @cloud == 'ec2' && device_type == 'hd'
            # this is probably HVM
            'xvd'
          else
            device_type
          end
        end

        def get_next_devices(count, exclusions = [])
          partitions = get_current_devices

          # The AWS EBS documentation recommends using /dev/sd[f-p] for
          # attaching volumes.
          #
          # http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-attaching-volume.html
          #
          if @cloud == "ec2" && partitions.last =~ /^\/dev\/(s|xv)d[a-d][0-9]*$/
            partitions << "/dev/#{$1}de"
          end

          if partitions.first =~ /^\/dev\/([a-z]+d)[a-z]+$/
            type = $1

            if @cloud == 'ec2' && type == 'hd'
              # this is probably HVM
              hvm = true
              # Root device is /dev/hda on HVM images, but volumes are xvd in
              # /proc/partitions, but can be referenced as sd also (mount shows sd) - PS
              type.sub!('hd','xvd')
            end

            partitions.select do |partition|
              partition =~ /^\/dev\/#{type}[a-z]+$/
            end.last =~ /^\/dev\/#{type}([a-z]+)$/

            if hvm
              # this is a HVM image, need to start at sdf at least
              letters = (['e', $1].max .. 'zzz')
            else
              letters = ($1 .. 'zzz')
            end
            letters.select do |letter|
              letter != letters.first && !exclusions.include?(letter) && count != -1 && (count -= 1) != -1
            end
          elsif partitions.first =~ /^\/dev\/([a-z]+d[a-z]*)\d+$/
            type = $1
            partitions.select do |partition|
              partition =~ /^\/dev\/#{type}\d+$/
            end.last =~ /^\/dev\/#{type}(\d+)$/
            number = $1.to_i
            (number + 1 .. number + count)
          else
            raise "unknown partition/device name: #{partitions.first}"
          end.map {|letter| "/dev/#{type}#{letter}"}
        end

        def get_root_device
          raise 'could not find root device' unless mount(nil, nil, :return_output => true) =~ /^([a-zA-Z\/]+)[0-9]+ on \/ /
          $1
        end

        def make_device_label(device, label_type)
          execute("parted --script #{device} mklabel #{label_type}", :return_output => true)
        end
        
        def get_device_partition_info(device)
          parted = execute("parted --script #{device} unit b print", :return_output => true)
          parted =~ /^Disk .+: (\d+)B$/
          info = {:size => $1.to_i, :partitions => {}}
          parted.split("\n").each do |line|
            if line =~ /^\s*(\d+)\s+(\d+)B\s+(\d+)B\s+(\d+)B\s+([^\s]+)\s*([^\s]*)\s*([^\s]*)\s*$/
              index = $1.to_i
              info[:partitions][index] = {:start => $2.to_i, :end => $3.to_i, :size => $4.to_i, :type => $5}
              info[:partitions][index][:fs] = $6 unless $6.empty?
              info[:partitions][index][:flags] = $7 unless $7.empty?
            end
          end
          info
        end

        def mount(mount_point_or_device, mount_point = nil, options = {})
          if mount_point
            device = mount_point_or_device
          else
            mount_point = mount_point_or_device
          end
          FileUtils.mkdir_p mount_point if mount_point && !File.exists?(mount_point)

          cmd =  StringIO.open do |cmd|
            cmd << 'mount '
            if options[:options]
              cmd << '-o '
              case options[:options]
              when Array
                cmd << options[:options].join(',')
              else
                cmd << options[:options]
              end
              cmd << ' '
            end
            cmd << device + ' ' if device
            cmd << mount_point if mount_point
            cmd.string
          end

          execute(cmd, options)
        end

        def mount_snapshot(device, mount_point, options = {})
          mount_snapshot_options = @filesystem.mount_snapshot_options
          if mount_snapshot_options
            options[:options] ||= []
            case options[:options]
            when Array
              options[:options] += mount_snapshot_options
            else
              options[:options] += [options[:options]] + mount_snapshot_options
            end
          end

          # Ubuntu 12.04 on google takes a few seconds for the snapshot device to become available
          # and the recipe fails. So this block waits for 2 minutes or till the device becomes available.
          Timeout::timeout(120) do
            until File.exists?(device) do
              @logger.info "Waiting for snapshot device to become available."
              sleep 2
            end
          end
          mount(device, mount_point, options)
        end

        def umount(mount_point_or_device)
          @logger.info `umount #{mount_point_or_device}`
          $?.success?
        end

        def lvcreate(devices, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'lvcreate '
            cmd << "--extents #{options[:extents]} " if options[:extents]
            cmd << "--name #{options[:name]} " if options[:name]
            cmd << '--snapshot ' if options[:snapshot]
            cmd << "--stripes #{options[:stripes]} " if options[:stripes]
            cmd << "--stripesize #{options[:stripesize]} " if options[:stripes]
            case devices
            when Array
              cmd << devices.join(' ')
            else
              cmd << devices
            end
            cmd.string
          end

          execute(cmd, options)
        end
        def lvchange(device, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'lvchange '
            cmd << "--available #{options[:available]} " if options[:available]
            cmd << device
            cmd.string
          end

          execute(cmd, options)
          # Verify that device path is in expected state
          if options[:available] =~  /^[y|n]$/
            # LVM bug in Ubuntu 12.04 turns device into a directory:
            # https://bugs.launchpad.net/ubuntu/+source/lvm2/+bug/1152369
            raise "Known Ubuntu/LVM bug - LVM device turned into directory" if File.directory?(device)

            5.downto(0) do |check_counter|
              device_sym_bool = File.symlink?(device)
              # Device asked to be available and appears to exists.
              if device_sym_bool && options[:available] == "y"
                @logger.info "Device #{device} exists as expected."
                break
              # Device asked to be UNavailable and appears to NOT exists.
              elsif !device_sym_bool && options[:available] == "n"
                @logger.info "Device #{device} does not exist as expected."
                break
              elsif check_counter == 0
                raise "lvchange failed to update device: '#{cmd.string}'"
              else
                @logger.info "Device #{device} not in expected state - waiting."
                sleep 2
              end
            end

          end

        end

        def lvremove(device, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'lvremove '
            cmd << '--force ' if options[:force]
            cmd << device
            cmd.string
          end

          execute(cmd, options)
        end

        def pvcreate(devices, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'pvcreate '
            cmd << '--force ' if options[:force]
            cmd << '--yes ' if options[:yes]
            case devices
            when Array
              cmd << devices.join(' ')
            else
              cmd << devices
            end
            cmd.string
          end

          execute(cmd, options)
        end

        def pvremove(devices, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'pvremove '
            case devices
            when Array
              cmd << devices.join(' ')
            else
              cmd << devices
            end
            cmd.string
          end

          execute(cmd, options)
        end

        def pvscan(options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'pvscan '
            cmd.string
          end

          execute(cmd, options)
        end

        def vgcreate(vgname, devices, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'vgcreate '
            cmd << vgname + ' '
            case devices
            when Array
              cmd << devices.join(' ')
            else
              cmd << devices
            end
            cmd.string
          end

          execute(cmd, options)
        end

        def vgremove(device, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'vgremove '
            cmd << device
            cmd.string
          end

          execute(cmd, options)
        end

        def vgs(devices, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'vgs '
            cmd << '--aligned ' if options[:aligned]
            cmd << '--noheadings ' if options[:noheadings]
            cmd << "--separator '#{options[:separator].gsub(/'/, "\\\\'")}' " if options[:separator]
            if devices
              case devices
              when Array
                cmd << devices.join(' ')
              else
                cmd << devices
              end
            end
            cmd.string
          end

          execute(cmd, options)
        end

        def vgremove(device, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'vgremove '
            cmd << device
            cmd.string
          end

          execute(cmd, options)
        end

        def vgrename(old_name, new_name, options = {})
          cmd = StringIO.open do |cmd|
            cmd << 'vgrename '
            cmd << old_name + ' ' + new_name
            cmd.string
          end

          execute(cmd, options)
        end

        def mkfs(device, options = {})
          execute("#{@filesystem.mkfs_command} #{device}", options)
        end

        def sync
          @logger.info `sync`
        end

        def enable_volume(device)
          @logger.info 'enabling logical volume...'
          pvscan
          lvchange(device, :available => 'y')
          @logger.info 'enabled.'
        end

        def disable_volume(device)
          @logger.info 'disabling logical volume...'
          lvchange(device, :available => 'n', :retry_num => 5, :retry_sleep => 1)
          @logger.info 'disabled.'
        end

        def get_devices_for_volume(device)
          # use volume-group name to detect 'physical' device names
          pvs = `pvdisplay -c`
          pvs.collect do |d|
            pd, vg, _ = d.split(/:/)
            pd.gsub!(/^\s+/,"")
            pd if vg == vgname_from_device(device)
          end.reject { |s| s.nil? }
        end

        def grow_device(mount_point, options = {})
          options = options.dup
          options[:vg_data_percentage] ||= 50
          log_info "Growing device at #{mount_point}..."
          # Grow the Physical Volume(s).  Assume all devs are in part of Logical Volume
          device = get_device_for_mount_point(mount_point)
          devices = get_devices_for_volume(device)
          devices.each do |pv|
            log_info "running pvresize on #{pv}..."
            execute("pvresize #{pv}", :ignore_failure => true)
          end

          # Unmount lv in order to do changes.
          umount(device)

          # Inactivate lv in order to run lvextend
          disable_volume(device)

          # Running lvextend to grow lv
          #  There are times when a restored volume is already 50% of the whole volume.
          #  When this occurs, lvextend exits with an error. This is why failure is ignored.
          log_info "running lvextend on #{device}..."
          execute("lvextend -l #{options[:vg_data_percentage]}%VG -n #{device}", :ignore_failure => true)

          # Reactivate volume
          enable_volume(device)

          # re mount file system
          mount(device)

          # Grow the file system
          case @filesystem.growfs_parameter_type
          when :device
            parameter = get_device_for_mount_point(mount_point)
          when :mount_point
            parameter = mount_point
          else
            raise "Unknown growfs parameter type: #{@filesystem.growfs_parameter_type.inspect}"
          end
          execute("#{@filesystem.growfs_command} #{parameter}")
        end

        def scan_for_attachments
          # vmware/esx requires the following 'hack' to make OS/Linux aware of device.
          # Check for /sys/class/scsi_host/host0/scan if need to run.
          if File.exist?("/sys/class/scsi_host/host0/scan")
            execute("echo '- - -' > /sys/class/scsi_host/host0/scan")
            sleep 5
          end
        end

        def get_volume_list
          execute("vgs --noheadings", :return_output => true).split(/\n/).map { |value| value.split.first }
        end

      private

        def vgname_from_device(device_name)
          _, _, vgname = device_name.split(/\//)
          vgname
        end

      end
    end
  end
end
