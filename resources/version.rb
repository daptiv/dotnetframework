# encoding: UTF-8

# Author:: Daptiv Engineering (<cpc_sea_teamengineering@changepoint.com>)
# Cookbook Name:: dotnetframework
# Resource:: edition
#
# Copyright 2018 Changepoint
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

actions :install
default_action :install

# The full .NET version: 4.0.30319, 4.5.51641 etc
attribute :version, kind_of: String, name_attribute: true

# The offline installer package URL
attribute :source, kind_of: String, required: true

# The installed MSI package name
attribute :package_name, kind_of: String, required: true

# The source ISO SHA256 checksum
attribute :checksum, kind_of: String
