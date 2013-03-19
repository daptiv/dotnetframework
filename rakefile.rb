require 'tailor/rake_task'
require 'foodcritic'

task :default => [:tailor, :foodcritic]

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
    STDERR.puts ('Default Foodcritic Failed!!!!!')
    STDERR.puts (review)
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
    STDERR.puts ('Tailor Failed!!!!!')
    raise(SystemExit, 1)
  else
    puts 'Tailor Passed!'
  end
end
