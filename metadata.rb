name 'dotnetframework'
maintainer 'Daptiv Solutions, LLC'
maintainer_email 'sneal@sneal.net'
license 'All rights reserved'
description 'Installs/Configures .NET Framework'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
ver_path = File.join(File.dirname(__FILE__), 'version.txt')
version File.exist?(ver_path) ? IO.read(ver_path).chomp : '1.1.0'
issues_url 'https://github.com/daptiv/dotnetframework/issues'
source_url 'https://github.com/daptiv/dotnetframework/'
supports 'windows'
depends 'windows', '>= 1.2.6'
