# dotnetframework cookbook

Installs and configures the .NET framework 4, 4.5, 4.5.1, or 4.5.2 runtime

# Requirements

Tested on Windows Server 2008 R2, should work on versions of Windows supported
by the associated .NET installer.

# Usage

Include the default recipe in your run list.

# Attributes

default
-------

* `node['dotnetframework']['version']` - defaults to '4.5.2' Acceptable values: '4.0', '4.5', '4.5.1', '4.5.2'.

# Recipes

default
-------

Installs the .NET Framework

# Author

Author:: Daptiv Engineering
