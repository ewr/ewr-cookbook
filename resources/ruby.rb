default_action :install
actions :link
attribute :version,   :kind_of => String, :name_attribute => true
attribute :directory, :kind_of => String
attribute :user,      :kind_of => String