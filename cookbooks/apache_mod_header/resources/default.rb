default_action :set
actions :set

attribute :key, :kind_of => String, :name_attribute => true
attribute :value, :kind_of => String, :default => nil
