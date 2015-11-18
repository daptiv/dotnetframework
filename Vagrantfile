# encoding: UTF-8

Vagrant.configure('2') do |config|
  config.vm.box = 'vbox_windows-2008r2_chef-11.12.4'
  config.vm.box_url = 'http://vagrantboxes.hq.daptiv.com/vagrant/boxes/vbox_windows-2008r2_chef-11.12.4.box'
  config.vm.communicator = :winrm
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.add_recipe 'chef_handler'
    chef.add_recipe 'minitest-handler'
    chef.add_recipe 'dotnetframework'
  end
end
