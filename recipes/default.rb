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

version        = node['dotnetframework']['version']
package_name   = node['dotnetframework'][version]['package_name']
url            = node['dotnetframework'][version]['url']
checksum       = node['dotnetframework'][version]['checksum']

setup_exe      = ::File.basename(url)
setup_log_path = win_friendly_path(File.join(Dir.tmpdir(), "#{setup_exe}.html"))
installer_cmd  = "/q /norestart /log \"#{setup_log_path}\""

dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
node.set['dotnetframework']['dir'] = dotnet4dir

windows_reboot 60 do
  reason 'dotnetframework requires a reboot to complete'
  action :nothing
end

windows_package package_name do
  source url
  checksum checksum
  installer_type :custom
  options installer_cmd
  action :install
  notifies :request, 'windows_reboot[60]', :immediately
end
