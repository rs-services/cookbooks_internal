default_action :install
#install actions
actions :install, :upgrade, :remove, :publish

#usage actions
actions :start, :stop, :restart

attribute :package_name, :kind_of => String, :name_attribute => true
attribute :version, :default => nil

