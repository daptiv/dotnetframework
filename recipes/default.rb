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
is_remote_file = !(download_url =~ /^http/).nil?

if is_remote_file then
  setup_exe_path = File.join(Dir.tmpdir(), setup_exe)
else
  setup_exe_path = download_url if !is_remote_file
end
setup_log_path = "#{setup_exe_path}.html"

dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
node.set['dotnetframework']['dir'] = dotnet4dir

if !(setup_exe =~ /^dotNetFx45/).nil? then
  Chef::Log.debug('.NET 4.5 framework specified')
  package_name = 'Microsoft .NET Framework 4.5'
  dotnet_is_installed = File.exists?(File.join(dotnet4dir, 'Microsoft.Activities.Build.dll'))
else
  Chef::Log.debug('.NET 4.0 framework specified')
  package_name = 'Microsoft .NET Framework 4 Extended'
  dotnet_is_installed = File.exists?(dotnet4dir)
end

windows_reboot 60 do
  reason 'dotnetframework requires a reboot to complete'
  action :nothing
end

remote_file setup_exe do
  source download_url
  path setup_exe_path
  backup false
  only_if { !dotnet_is_installed && is_remote_file }
end

windows_package package_name do
  source setup_exe_path
  installer_type :custom
  options "/q /norestart /log \"#{setup_log_path}\""
  action :install
  notifies :request, 'windows_reboot[60]'
  not_if { dotnet_is_installed }
end

