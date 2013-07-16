# -*- mode: ruby -*-
# vi: set ft=ruby :

load "config/prefs.rb"

Vagrant.configure("2") do |config|
  

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = $config_base_box

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = $config_base_box_url

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  
  config.vm.network :private_network, ip: $config_ip

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "www", "/mnt/www"
  config.vm.synced_folder "puppet/files", "/puppet_files"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "base.pp"
  end

end
