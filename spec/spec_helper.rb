require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.platform = 'windows'
  config.version = '2012R2'

  config.before(:each) do
    # Set some common global ENV vars used by Windows cookbooks
    ENV['WINDIR'] = 'C:\Windows'
    stub_const('File::ALT_SEPARATOR', '\\')
  end
end
