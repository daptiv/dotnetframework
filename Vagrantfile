Vagrant.configure("2") do |config|
  config.vm.box = "daptiv/windows2012r2_chef12"
  config.vm.communicator = :winrm
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.add_recipe "chef_handler"
    chef.add_recipe "minitest-handler"
    chef.add_recipe "dotnetframework"
  end
end
