name 'dotnetframework'
maintainer 'Changepoint'
maintainer_email 'cpc_sea_teamengineering@changepoint.com'
license 'All rights reserved'
description 'Installs/Configures .NET Framework'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
ver_path = File.join(File.dirname(__FILE__), 'version.txt')
version File.exist?(ver_path) ? IO.read(ver_path).chomp : '2.0.0'
chef_version '>= 13.0' if respond_to?(:chef_version)
issues_url 'https://github.com/daptiv/dotnetframework/issues'
source_url 'https://github.com/daptiv/dotnetframework/'
supports 'windows'
depends 'windows', '>= 1.2.6'
