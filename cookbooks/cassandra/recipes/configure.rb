#
# Cookbook Name:: cassandra
# Recipe:: configure
#
# Copyright 2012, RightScale Inc
#
# All rights reserved - Do Not Redistribute 
#

class Chef::Recipe
  include TokenGenerator
end

rightscale_marker :begin

token = generate_initial_token(node['cassandra']['node_number'], node['cassandra']['node_total'])

template "/etc/cassandra/cassandra.yaml" do
  source "cassandra.yaml.erb"
  mode "0644"
  owner "root"
  group "root"
  variables({
    :initial_token                        => token,
    :version                              => node['cassandra']['version'],
    :cluster_name                         => node['cassandra']['cluster_name'],
    :node_number                          => node['cassandra']['node_number'],
    :node_total                           => node['cassandra']['node_total'],
    :seeds                                => node['cassandra']['seeds'],
    :data_file_directories                => node['cassandra']['data_file_directories'],
    :commitlog_directory                  => node['cassandra']['commitlog_directory'],
    :saved_caches_directory               => node['cassandra']['saved_caches_directory'],
    :hinted_handoff_enabled               => node['cassandra']['hinted_handoff_enabled'],
    :max_hint_window_in_ms                => node['cassandra']['max_hint_window_in_ms'],
    :hinted_handoff_throttle_delay_in_ms  => node['cassandra']['hinted_handoff_throttle_delay_in_ms'],
    :key_cache_size_in_mb                 => node['cassandra']['key_cache_size_in_mb'],
    :key_cache_save_period                => node['cassandra']['key_cache_save_period'],
    :row_cache_size_in_mb                 => node['cassandra']['row_cache_size_in_mb'],
    :row_cache_save_period                => node['cassandra']['row_cache_save_period'],
    :commitlog_sync                       => node['cassandra']['commitlog_sync'],
    :commitlog_sync_period_in_ms          => node['cassandra']['commitlog_sync_period_in_ms'],
    :commitlog_segment_size_in_mb         => node['cassandra']['commitlog_segment_size_in_mb'],
    :flush_largest_memtables_at           => node['cassandra']['flush_largest_memtables_at'],
    :reduce_cache_sizes_at                => node['cassandra']['reduce_cache_sizes_at'],
    :reduce_cache_capacity_to             => node['cassandra']['reduce_cache_capacity_to'],
    :concurrent_reads                     => node['cassandra']['concurrent_reads'],
    :concurrent_writes                    => node['cassandra']['concurrent_writes'],
    :memtable_flush_queue_size            => node['cassandra']['memtable_flush_queue_size'],
    :trickle_fsync                        => node['cassandra']['trickle_fsync'],
    :trickle_fsync_interval_in_kb         => node['cassandra']['trickle_fsync_interval_in_kb'],
    :storage_port                         => node['cassandra']['storage_port'],
    :ssl_storage_port                     => node['cassandra']['ssl_storage_port'],
    :listen_address                       => node['cassandra']['listen_address'],
    :rpc_address                          => node['cassandra']['rpc_address'],
    :rpc_port                             => node['cassandra']['rpc_port'],
    :rpc_keepalive                        => node['cassandra']['rpc_keepalive'],
    :rpc_server_type                      => node['cassandra']['rpc_server_type'],
    :thrift_framed_transport_size_in_mb   => node['cassandra']['thrift_framed_transport_size_in_mb'],
    :thrift_max_message_length_in_mb      => node['cassandra']['thrift_max_message_length_in_mb'],
    :incremental_backups                  => node['cassandra']['incremental_backups'],
    :snapshot_before_compaction           => node['cassandra']['snapshot_before_compaction'],
    :auto_snapshot                        => node['cassandra']['auto_snapshot'],
    :column_index_size_in_kb              => node['cassandra']['column_index_size_in_kb'],
    :in_memory_compaction_limit_in_mb     => node['cassandra']['in_memory_compaction_limit_in_mb'],
    :multithreaded_compaction             => node['cassandra']['multithreaded_compaction'],
    :compaction_throughput_mb_per_sec     => node['cassandra']['compaction_throughput_mb_per_sec'],
    :compaction_preheat_key_cache         => node['cassandra']['compaction_preheat_key_cache'],
    :rpc_timeout_in_ms                    => node['cassandra']['rpc_timeout_in_ms'],
    :endpoint_snitch                      => node['cassandra']['endpoint_snitch'],
    :dynamic_snitch_update_interval_in_ms => node['cassandra']['dynamic_snitch_update_interval_in_ms'],
    :dynamic_snitch_reset_interval_in_ms  => node['cassandra']['dynamic_snitch_reset_interval_in_ms'],
    :dynamic_snitch_badness_threshold     => node['cassandra']['dynamic_snitch_badness_threshold'],
    :request_scheduler                    => node['cassandra']['request_scheduler'],
    :index_interval                       => node['cassandra']['index_interval']
  })
  notifies :restart, "service[cassandra]"
end

# Remove initial data/log dirs created by package install and autostart.
%w[/var/log/cassandra /var/lib/cassandra].each do |dir|
  directory "#{dir}" do
    action :delete
    recursive true
  end
end

service "cassandra" do
  action :nothing
end

rightscale_marker :end
