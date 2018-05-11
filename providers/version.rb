#
# Author:: Shawn Neal (<sneal@sneal.net>)
# Cookbook Name:: dotnetframework
# Provider:: version
#
# Copyright 2015, Shawn Neal
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Windows::Helper

def whyrun_supported?
  true
end

use_inline_resources

action :install do
  if dotnet_version_or_higher_is_installed?(new_resource.version)
    Chef::Log.info(
      ".NET Framework #{new_resource.version} or higher is already installed"
    )
  else
    converge_by("Installing .NET Framework #{new_resource.version}") do
      setup_exe = ::File.basename(new_resource.source)
      setup_log_path =
        win_friendly_path(::File.join(::Dir.tmpdir, "#{setup_exe}.html"))

      windows_package new_resource.package_name do # ~FC009
        source new_resource.source
        checksum new_resource.checksum
        installer_type :custom
        options "/q /norestart /log \"#{setup_log_path}\""
        action :install
        returns [0, 3010]
      end
    end
  end
end

def dotnet_version_or_higher_is_installed?(expected_version)
  reg_path = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
  require 'win32/registry'
  ::Win32::Registry::HKEY_LOCAL_MACHINE.open(reg_path) do |reg|
    reg_version = reg['Version']
    return Gem::Version.new(reg_version) >= Gem::Version.new(expected_version)
  end
rescue ::Win32::Registry::Error
  false
end
