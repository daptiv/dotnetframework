#
# Author:: Shawn Neal (<sneal@daptiv.com>)
# Cookbook Name:: dotnetframework
# Recipe:: default
#
# Copyright:: Copyright (c) 2013 Daptiv Solutions LLC.
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

download_url   = node['dotnetframework']['url']
setup_exe      = ::File.basename(download_url)
setup_exe_path = File.join(Dir.tmpdir(), setup_exe)
setup_log_path = "#{setup_exe_path}.html"

base_uninstall_reg_key = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\"
package_name   = "Microsoft .NET Framework 4 Extended"
uninstall_reg_key = base_uninstall_reg_key + package_name

if !(setup_exe =~ /^dotNetFx45/).nil? then
  Chef::Log.debug(".NET 4.5 framework specified")
  uninstall_reg_key = base_uninstall_reg_key + "{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}"
  package_name   = "Microsoft .NET Framework 4.5"
else
  Chef::Log.debug(".NET 4.0 framework specified")
end

#TODO: Support local install from c:\\vagrant

dotnet_is_installed = registry_key_exists?(uninstall_reg_key)

windows_reboot 10 do
  reason '.NET framework requires a reboot'
  action :nothing
end

remote_file setup_exe do
  source download_url
  path setup_exe_path
  backup false
  not_if { dotnet_is_installed }
end

windows_package package_name do
  source setup_exe_path
  installer_type :custom
  options "/q /norestart /log \"#{setup_log_path}\""
  action :install
  not_if { dotnet_is_installed }
  
end
