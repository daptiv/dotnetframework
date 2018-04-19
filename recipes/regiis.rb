#
# Author:: Daptiv Engineering (<cpc_sea_teamengineering@changepoint.com>)
# Cookbook Name:: dotnetframework
# Recipe:: regiis
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
# rubocop:disable Method/LineLength
# C:\Windows\System32\inetsrv>appcmd list config /section:isapiCgiRestriction
# <system.webServer>
#   <security>
#     <isapiCgiRestriction>
#       <add path="%windir%\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll" \
#         allowed="true" groupId="ASP.NET v2.0.50727" />
#       <add path="%windir%\Microsoft.NET\Framework\v2.0.50727\aspnet_isapi.dll" \
#         allowed="true" groupId="ASP.NET v2.0.50727" />
#     </isapiCgiRestriction>
#   </security>
# </system.webServer>

dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
aspnet_regiis_cmd = File.join(dotnet4dir, 'aspnet_regiis.exe')
appcmd = File.join(ENV['WINDIR'], 'system32\\inetsrv\\appcmd.exe')

execute 'aspnet_regiis' do
  command "#{aspnet_regiis_cmd} -i"
  action :run
  not_if do
    cmd = Mixlib::ShellOut.new("#{appcmd} list config /section:isapiCgiRestriction")
    aspnet_isapis = cmd.run_command
    Chef::Log.debug(aspnet_isapis.stdout)
    aspnet_isapis.stdout.include?('Framework64\\v4.0.30319\\aspnet_isapi.dll')
  end
end
