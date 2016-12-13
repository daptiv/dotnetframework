begin
  gem 'minitest-chef-handler'
rescue Gem::LoadError
  sh 'chef gem install minitest-chef-handler'
end

task default: [:version, :rubocop, :foodcritic, :spec, :kitchen]
task nokitchen: [:version, :rubocop, :foodcritic, :spec]

task :version do
  version = ENV['BUILD_NUMBER'] ? "1.2.#{ENV['BUILD_NUMBER']}" : '1.2.0'
  IO.write('version.txt', version)
end

task :foodcritic do
  sh 'chef exec foodcritic . -G -f any'
end

task :rubocop do
  sh 'chef exec rubocop'
end

task :spec do
  cmd = 'chef exec rspec --color -f documentation '
  cmd += '-tunit --pattern "spec/**/*_spec.rb"'
  sh cmd.to_s
end

task :kitchen do
  sh 'chef exec kitchen test -c'
end
