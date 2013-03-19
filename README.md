# dotnetframework cookbook

Installs and configures the .NET framework runtime

# Requirements

Tested on Windows Server 2008 R2
May work on Windows 7 or 8

# Usage

Include the default recipe in your run list.

# Attributes

default
-------

* `node['dotnetframework']['url']` - defaults to .NET 4.0 http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe

# Recipes

default
-------

Installs the .NET Framework (4 or 4.5)

# Author

Author:: Daptiv Engineering
