begin
  require 'berkshelf/vagrant'
rescue LoadError
  puts "[WARNING] Berkshelf not found in your Vagrant's RubyGems but your Vagrantfile is attempting"
  puts "[WARNING] to require the Berkshelf Vagrant plugin! Install the Berkshelf Vagrant plugin or"
  puts "[WARNING] remove the 'require \"berkshelf/vagrant\"' line from the top of your Vagrantfile."
  puts ""
  puts "If you installed Vagrant by RubyGems:"
  puts "  Install Berkshelf by running: \"gem install berkshelf\""
  puts "If you installed Vagrant by one of the pre-packaged installers:"
  puts "  Install Berkshelf by running: \"vagrant gem install berkshelf\""
  puts ""
end

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.winrm.timeout = 1800     #Set WinRM Timeout in seconds (Default 30)

  # Configure base box parameters
  config.vm.box = "vagrant-windows2008r2"
  config.vm.guest = :windows

  config.vm.forward_port 3389, 3389, :name => "rdp", :auto => true
  config.vm.forward_port 5985, 5985, :name => "winrm", :auto => true

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "33.33.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.

  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.cookbooks_path = "~/src/chef-repo/cookbooks"
    chef.roles_path = "~/src/chef-repo/roles"
    chef.data_bags_path = "~/src/chef-repo/data_bags"
    
    chef.add_recipe "chef_handler"
    chef.add_recipe "minitest-handler"
    chef.add_recipe "dotnetframework"
    
    #chef.json={
    #  "dotnetframework"=>{
    #    "url" => "c:/vagrant/dotNetFx40_Full_x86_x64.exe"
    #  }
    #}  
  end

end
