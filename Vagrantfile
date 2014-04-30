Vagrant.configure("2") do |config|

  config.vm.provider :vsphere do |vsphere|
    vsphere.insecure = true
    vsphere.host = ENV['vpshere_host']
    vsphere.data_center_name = ENV['vpshere_data_center_name']
    vsphere.data_store_name = ENV['vpshere_data_store_name']
    vsphere.compute_resource_name = ENV['vpshere_compute_resource_name']
    vsphere.resource_pool_name = ENV['vpshere_resource_pool_name']
    vsphere.template_name = 'Templates/windows-2008r2_chef-11.10.4'
    vsphere.user = ENV['vsphere_user']
    vsphere.password = ENV['vsphere_password']
  end

  config.vm.box = "vagrant-windows2008r2"
  config.vm.box_url = "http://vagrantboxes.hq.daptiv.com/vagrant/boxes/vagrant-windows2008r2.box"
  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box = "vagrant-vmware-windows2008r2sp1"
    override.vm.box_url = "http://vagrantboxes.hq.daptiv.com/vagrant/boxes/vagrant-vmware-windows2008r2sp1.box"
  end
  config.vm.provider :vsphere do |v, override|
    override.vm.box = "vsphere-dummy"
    override.vm.box_url = "http://vagrantboxes.hq.daptiv.com/vagrant/boxes/vsphere-dummy.box"
  end

  config.vm.guest = :windows
  config.vm.network :forwarded_port, guest: 5985, host: 5985, auto_correct: true
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.add_recipe "chef_handler"
    chef.add_recipe "minitest-handler"
    chef.add_recipe "dotnetframework"
  end

end
