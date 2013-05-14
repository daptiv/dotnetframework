require 'minitest/spec'

class TestDotNet4Install < MiniTest::Chef::TestCase

  def test_framework_was_installed
    dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
    assert Dir.exists?(dotnet4dir)
  end

end
