action :create do
  dir = node.ewr.app_path + "/" + new_resource.user
  
  # -- Create a User -- #
  
  user new_resource.user do 
    action :create
    system true
    shell "/bin/bash"
    home dir
    supports :manage_home => false
  end
  
  # -- Create a Home Directory -- #
  
  directory dir do
    action :create
    mode 0755
    owner new_resource.user
    recursive true
  end
  
  # -- Create Capistrano Directories -- #

  if new_resource.with_cap
    ['releases','shared','shared/system','shared/log','shared/pids'].each do |path|
      directory dir + "/" + path do
        action  :create
        owner   new_resource.user
        mode    0755
      end
    end
  end
  
  # -- Create SSH Directory -- #
  
  directory dir + "/.ssh" do
    action :create
    owner new_resource.user
    mode 0700
  end
  
  # -- Install known_hosts with Github -- #
  
  cookbook_file "known_hosts" do
    action  :create_if_missing
    path    dir+"/.ssh/known_hosts"
    mode    0600
    user    new_resource.user
  end
  
  # -- Install Deployment Key -- #
  
  item = data_bag_item(node.ewr.databag,new_resource.user)
  
  if item && item['deploy_key']
    file dir+"/.ssh/id_rsa" do
      action  :create
      content item['deploy_key']
      user    new_resource.user
      mode    0600
    end
  else
    log "Failed to find a deploy key for app #{new_resource.user}"
  end
  
  # -- Install SSH Access -- #
  
  if new_resource.with_ssh  
    keys = []
    search(node.ewr.users_databag, "groups:#{new_resource.user}_app AND NOT action:remove") do |u|
      keys << u['ssh_keys']
    end
  
    if keys.any?
      file dir+"/.ssh/authorized_keys" do
        action  :create
        content keys.flatten.sort.join("\n")
        user    new_resource.user
        mode    0600
      end
    else
      log "No access keys found for #{new_resource.user}"
    end
  end
  
  # -- Did they ask for a Ruby? -- #
  
  if new_resource.ruby
    ewr_ruby new_resource.ruby do
      action    [:install,:link]
      user      new_resource.user
      directory dir+"/bin"
    end
  end
  
  # -- Write a .bashrc with defaults -- #
  
  template dir+"/.bash_profile" do
    source "bash_profile.erb"
    action :create
    variables({resource:new_resource,dir:dir})
  end
  
end