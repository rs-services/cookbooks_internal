#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


# Add actions to @action_list array.
# Used to allow comments between entries.
def self.add_action(sym)
  @action_list ||= Array.new
  @action_list << sym unless @action_list.include?(sym)
  @action_list
end

# Attaching/Detaching options
attribute :backend_id, :kind_of => String, :default => ""
attribute :backend_ip, :kind_of => String, :default => ""
attribute :node_type, :kind_of => String, :default => ""
#attribute :namenodes, :kind_of => String, :default => ""
attribute :destination, :kind_of => String


add_action :start
add_action :stop
add_action :restart
add_action :attach
add_action :attach_request
add_action :detach
add_action :detach_request
add_action :code_update


actions @action_list


