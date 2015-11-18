require 'foodcritic'
require 'rspec/core/rake_task'

task :lint => [:version, :foodcritic, :spec]
task :default => [:lint]

task :version do
  IO.write('version.txt', (ENV['BUILD_NUMBER'] ? "1.1.#{ENV['BUILD_NUMBER']}" : '1.1.0'))
end

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    :cookbook_paths => '.',
    :search_gems => true }
end

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '-f documentation']
  task.rspec_opts << '-tunit'
end
