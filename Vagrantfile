# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.windows.halt_timeout = 15
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.box = "vagrant-windows2008r2"
  config.vm.box_url = "http://vmit07.hq.daptiv.com/vagrant/boxes/vagrant-windows2008r2.box"
  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box = "vagrant-vmware-windows2008r2sp1"
    override.vm.box_url = "http://vmit07.hq.daptiv.com/vagrant/boxes/vagrant-vmware-windows2008r2sp1.box"
  end
  config.vm.guest = :windows

  config.vm.network :forwarded_port, guest: 3389, host: 3389
  config.vm.network :forwarded_port, guest: 5985, host: 5985

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.cookbooks_path = "~/src/chef-repo/cookbooks"
    chef.roles_path = "~/src/chef-repo/roles"
    chef.data_bags_path = "~/src/chef-repo/data_bags"
    chef.add_recipe "chef_handler"
    chef.add_recipe "minitest-handler"
    chef.add_recipe "dotnetframework"
  end
end
