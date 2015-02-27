#
# Cookbook Name:: glusterfs
# Helper:: glusterfs_tags
#
# Copyright (C) 2014 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module GlusterFS
  module Tags
    
    # Find database servers using tags. This will find all active database servers, or, if `lineage` is
    # given, it will find all database servers for that linage, or, if `role` is specified it will find
    # the database server(s) with that role.
    #
    # @param node [Chef::Node] the Chef node
    # @param lineage [String] the lineage of the database servers to search for
    # @param role [String] the role of the database servers to search for; this should be `'master'` or
    #   `'slave'`
    #
    # @option options [Boolean] :only_latest_for_role (false) only return the latest server tagged for a role
    # @option options [Integer] :query_timeout (120) the seconds to timeout for the query operation
    #
    # @return [Mash] a hash with server UUIDs as keys and server information hashes as values
    #
    # @see http://rubydoc.info/gems/machine_tag/#MachineTag__Set MachineTag::Set
    #
    # @example Example master server hash
    #
    #     {
    #       '01-ABCDEF4567890' => {
    #         'tags' => MachineTag::Set[
    #           'database:active=true',
    #           'database:master_active=1391803034',
    #           'database:lineage=example',
    #           'server:public_ip_0=203.0.113.4',
    #           'server:private_ip_0=10.0.0.4',
    #           'server:uuid=01-ABCDEF4567890'
    #         ],
    #         'lineage' => 'example',
    #         'bind_ip_address' => '10.0.0.4',
    #         'bind_port' => 3306,
    #         'role' => 'master',
    #         'master_since' => Time.at(1391803034),
    #         'public_ips' => ['203.0.113.4'],
    #         'private_ips' => ['10.0.0.4']
    #       }
    #     }
    #
    # @example Example slave server hash
    #
    #     {
    #       '01-GHIJKL1234567' => {
    #         'tags' => MachineTag::Set[
    #           'database:active=true',
    #           'database:slave_active=1391803892',
    #           'database:lineage=example',
    #           'server:public_ip_0=203.0.113.5',
    #           'server:private_ip_0=10.0.0.5',
    #           'server:uuid=01-GHIJKL1234567'
    #         ],
    #         'lineage' => 'example',
    #         'bind_ip_address' => '10.0.0.5',
    #         'bind_port' => 3306,
    #         'role' => 'slave',
    #         'slave_since' => Time.at(1391803892),
    #         'public_ips' => ['203.0.113.5'],
    #         'private_ips' => ['10.0.0.5']
    #       }
    #     }
    #
    def self.find_gluster_servers_by_volume(node, volume_name =nil, options = {})
      require 'machine_tag'

      required_tags(options)


      query_tag = ::MachineTag::Tag.machine_tag('glusterfs_server', 'volume', volume_name)

      # Performs a tag search for database servers with given attributes.
      # See https://github.com/rightscale-cookbooks/machine_tag#tag_searchnode-query-options-- for more information
      # about this helper method.
      servers = Chef::MachineTagHelper.tag_search(node, query_tag, options)
      Chef::Log.info ""
      if volume_name
        servers.reject! do |tags|
          !tags.include?(::MachineTag::Tag.machine_tag('glusterfs_server', 'volume', volume_name))
        end
      end
      # Builds a Hash with server information obtained from each server from their tags.
      server_hashes = build_server_hash(servers) 

    end

    # Find database servers using tags. This will find all active database servers, or, if `lineage` is
    # given, it will find all database servers for that linage, or, if `role` is specified it will find
    # the database server(s) with that role.
    #
    # @param node [Chef::Node] the Chef node
    # @param lineage [String] the lineage of the database servers to search for
    # @param role [Symbol, String] the role of the database servers to search for; this should be `:master`
    #   or `:slave`
    #
    # @option options [Integer] :query_timeout (120) the seconds to timeout for the query operation
    #
    # @return [Mash] a hash with server UUIDs as keys and server information hashes as values
    #
    # @see .find_database_servers
    #
    def find_gluster_servers_by_volume(node, volumn_name, options = {})
      GlusterFS::Tags.find_gluster_servers_volume(node, volumn_name, options)
    end

    def self.find_gluster_servers_by_spare(node,tags, secondary_tags, volume_name, options={})
      require 'machine_tag'

      required_tags(options)


      #query_tag = ::MachineTag::Tag.machine_tag('glusterfs_server', 'volume', volume_name)

      # Performs a tag search for database servers with given attributes.
      # See https://github.com/rightscale-cookbooks/machine_tag#tag_searchnode-query-options-- for more information
      # about this helper method.
      servers = Chef::MachineTagHelper.tag_search(node, "#{tags}")

      if volume_name
        servers.reject! do |tags|
          !tags.include?(::MachineTag::Tag.machine_tag('glusterfs_server', 'volume', volume_name))
        end
      end
      
      # Builds a Hash with server information obtained from each server from their tags.
      server_hashes = build_server_hash(servers) 
      hosts_found=[]
      server_hashes.each do |id, tags| 
        hosts_found << tags["private_ips"].first
      end
      # (sanity check)
      if hosts_found.empty?
        raise "!!!> Didn't find any servers tagged with #{tags} " +
          "and #{secondary_tags}"
      end

      # Populate node attr
      node.override[:glusterfs][:server][:spares] = hosts_found
    end
    
    def find_gluster_servers_by_spare(node, tags, secondary_tags, volume_name)
      GlusterFS::Tags.find_gluster_servers_by_spare(node, tags, secondary_tags, volume_name)
    end
    
    private

    # Adds required tags to the options for Chef::MachineTagHelper#tag_search that are needed for the various
    # `find_*_servers` methods. By default it will add `server:uuid`, any other requirements need to be passed
    # as additional arguments. This method can be called multiple times to add further tag requirements.
    #
    # @param options [Hash] the options hash to populate
    # @param tags [Array<String>] the required tags
    #
    def self.required_tags(options, *tags)
      require 'set'

      options[:required_tags] ||= Set['server:uuid']
      options[:required_tags] += tags
    end

    # Builds a hash of server information hashes to be returned by the `find_*_servers` methods. A callback
    # block can be passed to further populate each server information hash from each tag set.
    #
    # @param servers [Array<MachineTag::Set>] the array of tag sets returned by Chef::MachineTagHelper#tag_search
    # @param block [Proc(MachineTag::Set)] a block that does further processing on each tag set; it should
    #   return a hash that will be merged into the server information hash
    #
    # @return [Mash] the hash with server UUIDs as keys and server information hashes as values
    #
    def self.build_server_hash(servers, &block)
      server_hashes = servers.map do |tags|
        uuid = tags['server:uuid'].first.value
        server_hash = {
          'tags' => tags,
          'public_ips' => tags[/^server:public_ip_\d+$/].map { |tag| tag.value },
          'private_ips' => tags[/^server:private_ip_\d+$/].map { |tag| tag.value },
        }

        server_hash.merge!(block.call(tags)) if block

        [uuid, server_hash]
      end

      Mash.from_hash(Hash[server_hashes])
    end
  end
end