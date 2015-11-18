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
include Windows::RegistryHelper

def whyrun_supported?
  true
end

action :install do
  if dotnet_version_is_installed?(new_resource.version)
    Chef::Log.info ".NET Framework #{new_resource.version} is already installed - skipping"
  else
    converge_by("Installing .NET Framework #{new_resource.version}") do

      setup_exe = ::File.basename(new_resource.source)
      setup_log_path = win_friendly_path(::File.join(::Dir.tmpdir(), "#{setup_exe}.html"))

      windows_package new_resource.package_name do
        source new_resource.source
        checksum new_resource.checksum
        installer_type :custom
        options "/q /norestart /log \"#{setup_log_path}\""
        action :install
        success_codes [0, 3010]
      end
    end
  end
end

def dotnet_version_is_installed?(reg_version)
  reg_path = 'HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
  Registry.key_exists?(reg_path) && Registry.get_value(reg_path, 'Version') == reg_version
end
