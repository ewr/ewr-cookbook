# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box       = "canonical-ubuntu-12.04"
  config.vm.box_url   = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  config.omnibus.chef_version = :latest
  
  config.vm.hostname = "ewr-cookbook-test"
  
  config.berkshelf.enabled = true
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm",:id,"--cpus",2]
    vb.customize ["modifyvm",:id,"--memory",1*1024]
  end
  
  config.vm.provision :chef_solo do |chef|    
    chef.json = {
      
    }
    
    chef.run_list = [
      "recipe[ewr::ewr]"
    ]
  end
end
