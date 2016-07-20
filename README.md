JRockit-JDK puppet module
=====================

Important:
---------------
- This module was originally in https://github.com/biemond/puppet. After owner's authorization, we splitted it and create a new, exclusive, JRockit-JDK repository.
- Thanks to Edwin Biemond.

Installs the jdk and optionally the jre, demos etc.
---------------------------------------------------

Installs the jrockit jdk on linux and windows based systems with 64 or 32 bit architecture. The approriate installer must be copied to the files directory of the module; for example jrockit-jdk1.6.0_45-R28.2.7-4.1.0-linux-x64.bin

The module does the following:

- downloads the installer to the download folder of the puppet agent host
- performs a silent installation
- adds to alternatives for linux systems
- optionally sets JRockit as default java

The default settings are:

- Demos are not installed
- Source is not installed
- The jre is installed
- The installed version is set as the default

Required settings:

- Version - must match the version component of filename of the installer
- x64 - true for 64 bit and false for 32 bit (Solaris/SPARC is not currently supported)

Optional Settings:

- puppetMountDir - Specify local mountpoint for install files
- downloadDir    - Local directory for installer downloads
- installDemos   - Install demos (default=false)
- installSource  - Install source code (default=false)
- installJre     - Install JRE (default=true)
- setDefault     - Set the installation as default (default=true)

Example usage
-------------

	include jrockit

	jrockit::installrockit {'jrockit-1.6.0_45':
	    version       => '1.6.0_45-R28.2.7-4.1.0',
	    x64           => 'true',
		downloadDir   =>  "/install/",
		installSource =>  'true',
	}
