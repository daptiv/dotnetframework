require 'tailor/rake_task'
require 'foodcritic'
require 'rbconfig'
require 'chef/config'

require_relative '../../build/rake_helper.rb'
require_relative '../../build/vagrant_helper.rb'
require_relative '../../build/vboxmanage_helper.rb'

# Use knife.rb and conventions to locate (vendored) cookbooks and data bags.
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

if is_windows then
  home_dir = File.join(ENV['HOMEDRIVE'], ENV['HOMEPATH'])
else
  home_dir = ENV['HOME']
end

knife_file = File.join(home_dir, '.chef', 'knife.rb')
Chef::Config.from_file(knife_file)
knife_cookbook_path = Chef::Config[:cookbook_path]
chef_repo_path = File.join(knife_cookbook_path, '..')
data_bag_path = File.join(knife_cookbook_path, '..', 'data_bags')

task :default => [:tailor, :foodcritic, :foodcritic_extended]
task :lint => [:tailor, :foodcritic, :foodcritic_extended]

desc 'Run foodcritic with default rule set.'
task :foodcritic do
  puts '@@@TASK: foodcritic'
  cookbook_path = '.'
  tags          = []
  fail_tags     = %w(any)
  include_rules = []

  options = { :tags => tags, :fail_tags => fail_tags, :include_rules => include_rules }
  review  = ::FoodCritic::Linter.new.check([cookbook_path], options)
  puts review
  if review.failed?
    STDERR.puts('Default Foodcritic Failed!!!!!')
    STDERR.puts(review)
    raise(SystemExit, 1)
  else
    puts 'Default Foodcritic Passed!'
  end
end

desc 'Run tailor code style tool.'
task :tailor do
  puts '@@@TASK: tailor'
  tailor_opts = []
  failure = Tailor::CLI.run(tailor_opts)
  if failure
    STDERR.puts('Tailor Failed!!!!!')
    raise(SystemExit, 1)
  else
    puts 'Tailor Passed!'
  end
end

desc 'Run foodcritic with extended rule set'
task :foodcritic_extended do
  puts '@@@TASK: foodcritic_extended'
  cookbook_path      = '.'
  tags               = []
  fail_tags          = %w(any)
  # foodcritic_rules is a submodule of the chef-repo.
  extended_rules_dir = File.join(chef_repo_path, 'foodcritic_rules')

  if Dir.exists?(extended_rules_dir)
    include_rules = [extended_rules_dir]
    options       = { :tags => tags, :fail_tags => fail_tags, :include_rules =>
      include_rules }
    review        = ::FoodCritic::Linter.new.check([cookbook_path], options)
    if review.failed?
      STDERR.puts('Extended Foodcritic Failed!!!!!')
      STDERR.puts(review)
      raise(SystemExit, 1)
    else
      puts 'Extended Foodcritic Passed!'
    end
  else
    STDERR.puts "Extended rules directory was not found at: #{extended_rules_dir}"
    STDERR.puts('Extended Foodcritic did not complete!!!!!')
    raise(SystemExit, 1)
  end

end

desc 'Run vagrant'
task :vagrant do

  VagrantHelper.vagrant_prereq

  begin
    VagrantHelper.vagrant_stop
  end

  begin
    VBoxManageHelper.vboxmanage_cleanup_target_vms('dotnetframework')
  end

  begin
    VagrantHelper.vagrant_file_overwrite
    VagrantHelper.vagrant_start
  ensure
    VagrantHelper.vagrant_stop
    VagrantHelper.vagrant_file_restore
    VBoxManageHelper.vboxmanage_cleanup_target_vms('dotnetframework')
    puts 'DONE'
  end

end
