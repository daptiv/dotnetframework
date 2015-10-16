# dotnetframework cookbook

Installs and configures the .NET framework 4, 4.5, 4.5.1, 4.5.2, or 4.6 runtime

# Requirements

Tested on Windows Server 2008 R2 and Windows Server 2012R2 should work on versions of Windows supported
by the associated .NET installer.

# Usage

Include the default recipe in your run list.

# Attributes

default
-------

* `node['dotnetframework']['version']` - defaults to '4.5.2' Acceptable values: '4.0', '4.5', '4.5.1', '4.5.2', '4.6'.

# Recipes

default
-------

Installs the .NET Framework

# Mini-Tests

You can include the mini-tests in your runlist to verify .NET was successfully installed, however .NET
will not work until you reboot.

.NET 4.6 minitests will fail until you reboot, so its best to run Chef with only dotnetframework in
your runlist, reboot, then include dotnetframework again with the minitest-handler.

# Author

Author:: Daptiv Engineering
