#
# Author:: Shawn Neal (<sneal@daptiv.com>)
# Cookbook Name:: dotnetframework
# Recipe:: regiis
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


#C:\Windows\Microsoft.NET\Framework64\v4.0.30319>aspnet_regiis -lv
#2.0.50727.0             C:\Windows\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll
#4.0.30319.0             C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_isapi.dll
#4.0.30319.0             C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll


#HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ASP.NET\4.0.30319.0
# If that key is present, then .Net 4 has been installed and is registered in IIS.

dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
aspnet_regiis_cmd = File.join(dotnet4dir, 'aspnet_regiis.exe')

execute "aspnet_regiis" do
  command "#{aspnet_regiis_cmd} -i -enable"
  action :run
  not_if do
    cmd = Mixlib::ShellOut.new("#{aspnet_regiis_cmd} -lv")
    aspnet_isapis = cmd.run_command
    Chef::Log.debug(aspnet_isapis.stdout)
    aspnet_isapis.stdout.include?('Framework64\\v4.0.30319\\aspnet_isapi.dll')
  end
end
