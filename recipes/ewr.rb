include_recipe "nginx_passenger"

# -- Pre-reqs -- #

package "imagemagick"

# -- Create a User and Directory -- #

ewr_app "ewr" do
  action      :create
  with_cap    true
  ruby        "1.9.1"
  env({RAILS_ENV:"production"})
end

dir = "#{node.ewr.app_path}/ewr"

# -- Install the Site File -- #

nginx_passenger_site "ewr" do
  action      :install
  dir         "#{dir}/current"
  server      "ewr.is"
  ruby        "/usr/bin/ruby1.9.1"
  rails_env   "production"
end

# -- Install Lifeguard and Tasks -- #

lifeguard_service "ewr.is Resque Pool" do
  action  [:enable,:start]
  command "bundle exec resque-pool"
  user    "ewr"
  dir     "#{dir}/current"
  service "ewr-resque"
  path    "#{dir}/bin"
  env({RAILS_ENV:"production"})
end