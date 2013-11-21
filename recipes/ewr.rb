include_recipe "nginx_passenger"

# -- Pre-reqs -- #

package "imagemagick"
package "libimage-exiftool-perl"

# -- Create a User and Directory -- #

ewr_app "ewr" do
  action      :create
  with_cap    true
  ruby        "1.9.1"
  env({RAILS_ENV:"production"})
end

dir = "#{node.ewr.app_path}/ewr"

# -- Make asset_images directory -- #

directory "/data/ewr/asset_images" do
  action    :create
  owner     "ewr"
  recursive true
end

# -- Install the Site File -- #

nginx_passenger_site "ewr" do
  action      :install
  dir         "#{dir}/current"
  server      "ewr.is"
  ruby        "/usr/bin/ruby1.9.1"
  rails_env   "production"
end

# -- Install some redirects -- #

template "/etc/nginx/sites-enabled/ewr-redirects" do
  action    :create
  notifies  :reload, "service[nginx]"
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