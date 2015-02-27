define :prune_spares, :replica_count=>2, :myip=>nil do

  #VOL_TYPE   = params[:volume_type]
  REPL_COUNT = params[:replica_count]
  IP_ADDR    = params[:myip]

  # Variable for final list of usable IPs (defaults to all found)
  hosts_final = spares = node[:glusterfs][:server][:spares]

  # The replication count determines what number of bricks you need when
  # adding to- or removing from the volume.
  #
  #if VOL_TYPE == "Replicated"
    # Do we have enough hosts to meet the replica count?
    num_found = spares.size
    if (num_found < REPL_COUNT)
      raise "!!!> Didn't find enough spare servers to satisfy " +
        "replication count of #{REPL_COUNT}."
    end

    # Do we have an even number of hosts (rather, divisible by replica_count)?
    remainder = num_found % REPL_COUNT
    if (remainder != 0)
      Chef::Log.info "WARN: Not all spares will be used. Number not " +
        "divisible by replication count '#{REPL_COUNT}'."

      # Make a list of the hosts we're going to use
      #
      # (the logic here is that we *always* want to use our own ip address, so
      # we're going to filter it out of the list and grab the appropriately-sized
      # slice of remaining hosts, then add ourselves to the final list)
      hosts_final = spares.reject{|i| i == IP_ADDR}[1..-remainder]
      hosts_final << IP_ADDR
    end
  #end #if VOL_TYPE=="Replicated"

  Chef::Log.info "===> Using hosts #{hosts_final.inspect}"
  node.override[:glusterfs][:server][:spares] = hosts_final

end
