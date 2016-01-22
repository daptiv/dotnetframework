# encoding: UTF-8

require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task lint: [:version, :rubocop, :foodcritic]
task default: [:lint, :spec]

task :version do
  IO.write('version.txt', (ENV['BUILD_NUMBER'] ? "1.2.#{ENV['BUILD_NUMBER']}" : '1.2.0'))
end

RuboCop::RakeTask.new

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    cookbook_paths: '.',
    search_gems: true }
end

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '-f documentation']
  task.rspec_opts << '-tunit'
end
