actions :delete
default_action :create

attribute :user, :kind_of => String, :name_attribute => true
attribute :with_ssh, :kind_of => [TrueClass,FalseClass], :default => true
attribute :with_cap, :kind_of => [TrueClass,FalseClass], :default => false
attribute :ruby, :kind_of => String
attribute :env, :kind_of => Hash