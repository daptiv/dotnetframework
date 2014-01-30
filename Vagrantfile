Vagrant.configure("2") do |config|
  config.vm.box = "vagrant-windows2008r2"
  config.vm.box_url = "http://vagrantboxes.hq.daptiv.com/vagrant/boxes/vagrant-windows2008r2.box"
  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box = "vagrant-vmware-windows2008r2sp1"
    override.vm.box_url = "http://vagrantboxes.hq.daptiv.com/vagrant/boxes/vagrant-vmware-windows2008r2sp1.box"
  end
  config.vm.guest = :windows
  config.vm.network :forwarded_port, guest: 5985, host: 5985, auto_correct: true
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
