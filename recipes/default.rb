# encoding: UTF-8

# Author:: Daptiv Engineering (<cpc_sea_teamengineering@changepoint.com>)
# Cookbook Name:: dotnetframework
# Recipe:: default
#
# Copyright:: Copyright (c) 2018 Changepoint
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

version = node['dotnetframework']['version']

dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
node.default['dotnetframework']['dir'] = dotnet4dir

reboot 'dotnetframework_install' do
  reason 'dotnetframework requires a reboot to complete'
  action :nothing
end

dotnetframework_version node['dotnetframework'][version]['version'] do
  source node['dotnetframework'][version]['url']
  package_name node['dotnetframework'][version]['package_name']
  checksum node['dotnetframework'][version]['checksum']
  notifies :request_reboot, 'reboot[dotnetframework_install]', :immediately
end
