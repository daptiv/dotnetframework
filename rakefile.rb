require 'tailor/rake_task'
require 'foodcritic'
require 'daptiv-chef-ci/vagrant_task'

task :lint => [:version, :tailor, :foodcritic]
task :default => [:lint]

task :version do
  IO.write('version.txt', (ENV['BUILD_NUMBER'] ? "0.1.#{ENV['BUILD_NUMBER']}" : '0.1.0'))
end

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    :cookbook_paths => '.',
    :search_gems => true }
end

Tailor::RakeTask.new
Vagrant::RakeTask.new
