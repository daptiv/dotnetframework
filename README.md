# Dotnetframework cookbook

Installs and configures the .NET framework 4, 4.5, 4.5.1, 4.5.2, or 4.6 runtime

# Requirements

Tested on Windows Server 2008 R2 and Windows Server 2012R2. The selected .NET
runtime should work on versions of Windows supported by the associated .NET
installer.

* Windows 2008
* Windows 2008 R2
* Windows 2012
* Windows 2012 R2

# Usage

Include the default recipe in your run list. The default recipe will install
the specified .NET framework version.

# Attributes

## default

* `node['dotnetframework']['version']` - defaults to '4.5.2' Acceptable values:
'4.0', '4.5', '4.5.1', '4.5.2', '4.6', '4.6.1', '4.6.2'.

# Recipes

## default

Installs the .NET Framework.

## regiis

This recipe register .NET with IIS so that IIS can host .NET application
associated with the specified intalled .NET version. This recipe currently
does not support Windows 2012 or higher. For Windows 2012 or newer its
recommended that you use the IIS cookbook to register the .NET version.

## mini-tests

You can include the mini-tests in your runlist to verify .NET was successfully
installed, however .NET will not work until you reboot.

.NET 4.6 minitests will fail until you reboot, so its best to run Chef with
only dotnetframework in your runlist, reboot, then include dotnetframework
again with the minitest-handler.

# TODO

- Install .NET using the windows_feature resource if the current OS supports it.
- Support older versions of .NET < 4.0.
- Support installation over WinRM (i.e. native scheduled task support).
- Abstract .NET installation to a Chef resource.

# Author

Author:: Shawn Neal (sneal@sneal.net)
