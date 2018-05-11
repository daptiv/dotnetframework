# rubocop:disable Metrics/BlockLength
task default: %i[version rubocop foodcritic spec kitchen cleanup]
task nokitchen: %i[version rubocop foodcritic spec]

desc 'Set cookbook version.'
task :version do
  version = ENV['BUILD_NUMBER'] ? "2.0.#{ENV['BUILD_NUMBER']}" : '2.0.0'
  IO.write('version.txt', version)
end

desc 'Foodcritic test.'
task :foodcritic do
  load_gems('colorize')
  puts 'Running Foodcritic tests...'.green
  sh 'chef exec foodcritic . -G -f any'
end

desc 'Rubocop test.'
task :rubocop do
  load_gems('colorize')
  puts 'Running Rubocop tests...'.green
  sh 'chef exec rubocop'
end

desc 'ChefSpec test.'
task :spec do
  load_gems('colorize minitest-chef-handler')
  puts 'Running ChefSpec tests...'.green
  cmd = 'chef exec rspec --color -f documentation ' \
   '-tunit --pattern "spec/**/*_spec.rb"'
  sh cmd.to_s
end

desc 'Test Kitchen.'
task :kitchen, [:type] => %i[check_env_vars assume_role] do |_t, args|
  task_thread = []
  kitchen_complete = false
  start_time = Time.now
  %w[kitchen assume_role].each do |task|
    task_thread << Thread.new do
      case task
      when 'kitchen'
        load_gems('colorize')
        puts 'Running Test Kitchen...'.green
        type = args[:type] || 'test'
        begin
          sh "chef exec kitchen #{type} -c"
        rescue StandardError => e
          Rake::Task[:cleanup].invoke if type == 'test'
          raise e.inspect
        end
        kitchen_complete = true
      when 'assume_role'
        while kitchen_complete == false
          current_time = Time.now
          elapsed_time = (current_time.to_f - start_time.to_f).to_i
          if elapsed_time > 3000
            Rake::Task[:assume_role].reenable
            Rake::Task[:assume_role].invoke
            start_time = Time.now
          end
          sleep 10
        end
      end
    end
  end
  task_thread.each(&:join)
end

desc 'Cleanup after yourself!'
task :cleanup, [:cookbook_name] => [:assume_role] do |_t, args|
  load_gems('colorize')
  puts "Clean up AWS in case test kitchen doesn't. . .".green
  cookbook_name = args.cookbook_name || File.basename(Dir.getwd)
  instance_cmd = 'aws ec2 describe-instances --filters ' \
   "\"Name=tag:Name,Values=#{cookbook_name}\" " \
   '"Name=instance-state-name,Values=running"'

  instance = `#{instance_cmd}`
  unless JSON.parse(instance)['Reservations'].empty?
    id = JSON.parse(instance)['Reservations'][0]['Instances'][0]['InstanceId']
    sh "aws ec2 terminate-instances --instance-ids #{id}"
  end
  puts "Cookbook #{cookbook_name} is cleaned up.".green
end

desc 'AWS Assume Role.'
task assume_role: :check_env_vars do
  load_gems('json colorize')

  puts "Assuming role for #{ENV['EC2_ROLE_ARN']}".green

  assume_role_cmd = 'aws sts assume-role ' \
    "--role-arn=#{ENV['EC2_ROLE_ARN']} " \
    '--role-session-name=temp_session'
  data = JSON.parse(`#{assume_role_cmd}`)

  access_key = data['Credentials']['AccessKeyId']
  secret_key = data['Credentials']['SecretAccessKey']
  token = data['Credentials']['SessionToken']

  system "aws configure set aws_access_key_id #{access_key}"
  system "aws configure set aws_secret_access_key #{secret_key}"
  system "aws configure set aws_session_token #{token}"
  system "aws configure set region #{ENV['EC2_REGION']}"

  ENV['AWS_ACCESS_KEY_ID'] = nil
  ENV['AWS_SECRET_ACCESS_KEY'] = nil

  puts "Role '#{ENV['EC2_ROLE_ARN']}' has been assumed.".green
end

desc 'Verify environment variables are set.'
task :check_env_vars do
  load_gems('colorize')
  @vars = []
  @file = File.new('docker-compose.yml', 'r')
  while (line = @file.gets)
    @vars << line.scan(/^\s+\b[A-Z0-9_]+:\s+\${(\w+)/).join('')
  end
  req_env_vars = @vars.reject(&:empty?)
  msg = ''
  req_env_vars.uniq.each do |env|
    next if env.include? '_DIR'
    msg += "\n#{env}" if ENV[env].to_s.empty?
  end
  raise 'Missing Environment Variables. . .'.red + msg.red unless msg.empty?
end

private

def load_gems(gems)
  gems.split(' ').each do |g|
    begin
      gem g
    rescue Gem::LoadError
      system "gem install #{g} --no-document"
      Gem.clear_paths
    end
    require g
  end
end
