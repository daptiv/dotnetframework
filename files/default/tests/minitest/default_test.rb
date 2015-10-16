require 'minitest/spec'
require 'win32/registry'

# Tests to ensure .NET 4 is installed
class TestDotNet4Install < MiniTest::Chef::TestCase
  def test_framework_dir_exists
    # all .NET versions are installed to the same v4.0.30319 folder
    dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
    assert Dir.exist?(dir)
  end

  # Determining installed .NET versions
  # http://support.microsoft.com/kb/318785
  # https://msdn.microsoft.com/en-us/library/hh925568(v=vs.110).aspx
  def test_framework_version
    major_version = node['dotnetframework']['version']
    path = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
    Win32::Registry::HKEY_LOCAL_MACHINE.open(path) do |reg|
      assert reg['Version'] == node['dotnetframework'][major_version]['version'], reg['Version']
    end
  end
end
