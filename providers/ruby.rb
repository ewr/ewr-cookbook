action :install do
  # Add the brightbox PPA
  apt_repository 'brightbox' do
    uri           'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
    distribution  node['lsb']['codename']
    components    ['main']
    keyserver     "keyserver.ubuntu.com"
    key           "C3173AA6"
    action        :add
  end

  case new_resource.version
  when "1.8"
    # -- Install Ruby 1.8 -- #
    
    ["libruby1.8","ruby1.8","ruby1.8-dev"].each do |p|
      package p do
        action  :install        
        version node.ewr.ruby18
      end
    end

    package "rubygems1.8"
    package "rake"
    package "ruby-bundler"

    # For consistency, link rake1.8 to rake
    link "/usr/bin/rake1.8" do
      to "/usr/bin/rake"
      action :create
    end
    
  when "1.9.1"
    ["libruby1.9.1","ruby1.9.1","ruby1.9.1-dev"].each do |p|
      package p do
        action  :install
        version node.ewr.ruby191
      end
    end

    package "ruby-bundler"
    
  when "2.0"
    ["libruby2.0","ruby2.0","ruby2.0-dev"].each do |p|
      package p do
        action  :install
        version node.ewr.ruby20
      end
    end

    package "ruby-bundler"
    
  else
    log "Asked to install an unknown Ruby: #{new_resource.version}"
  end
end

action :link do
  if new_resource.directory
    directory new_resource.directory do
      action :create
      owner new_resource.user
    end
    
    ["ruby","irb","gem","rake"].each do |p|
      link new_resource.directory+"/"+p do
        action :create
        to "/usr/bin/#{p}#{new_resource.version}"
      end
    end
  else
    log "Skipping ruby link since a directory wasn't given."
  end

end