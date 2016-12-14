# encoding: UTF-8

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
    expected_version = expected_dotnet_version
    reg_version = installed_dotnet_version
    flunk('Could not find a .NET version in the registry') unless reg_version
    assert(
      Gem::Version.new(reg_version) >= Gem::Version.new(expected_version),
      "Expected .NET version #{expected_version} or higher, " \
      "but only found #{reg_version}"
    )
  end

  def expected_dotnet_version
    major_version = node['dotnetframework']['version']
    node['dotnetframework'][major_version]['version']
  end

  def installed_dotnet_version
    path = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
    Win32::Registry::HKEY_LOCAL_MACHINE.open(path) do |reg|
      return reg['Version']
    end
  rescue ::Win32::Registry::Error
    return nil
  end
end
