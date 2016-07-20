# javaexec
# run the silent install
# set the default java links
# set this java as default

define jrockit_jdk::javaexec (
  $path        = undef,
  $version     = undef,
  $full_version = undef,
  $jdkfile     = undef,
  $set_default  = undef,
  $user        = undef,
  $jre_install_dir = undef,
  $group       = undef,
  ) {

  # install jdk
  case $::operatingsystem {
    CentOS, RedHat, OracleLinux, Ubuntu, Debian: {
      $exec_path    = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
      $java_install = $jre_install_dir
      $silentfile   = "${path}/silent${version}.xml"

      Exec {
        logoutput   => true,
        path        => $exec_path,
        user        => $user,
        group       => $group,
      }

      # Create the silent install xml
      file { "silent.xml ${version}":
        ensure  => present,
        path    => $silentfile,
        replace => 'yes',
        content => template('jrockit_jdk/jrockit-silent.xml.erb'),
        require => File[$path],
      }

      # Do the installation but only if the directry doesn't exist
      exec { 'installjrockit':
        command   => "${jdkfile} -mode=silent -silent_xml=${silentfile}",
        cwd       => $path,
        path      => $path,
        logoutput => true,
        require   => File["silent.xml ${version}"],
        creates   => $java_install,
      }
      # Add to alternatives and set as the default if required
      case $::operatingsystem {
        CentOS, RedHat, OracleLinux: {
          # set the java default
          exec { 'install alternatives':
            command => "alternatives --install /usr/bin/java java ${java_install}/bin/java 17065",
          }

          if $set_default == true {
            exec { 'default alternatives':
              command => "alternatives --set java ${java_install}/bin/java",
              require => Exec['install alternatives'],
            }
          }
        }
        Ubuntu, Debian: {
          # set the java default
          exec { 'install alternatives':
            command => "update-alternatives --install /usr/bin/java java ${java_install}/bin/java 17065",
          }

          if $set_default == true {
            exec { 'default alternatives':
              command => "update-alternatives --set java ${java_install}/bin/java",
              require => Exec['install alternatives'],
            }
          }
        }
        default: {
          fail('Unrecognized operating system')
        }
      }
    }
    default: {
      fail('Unrecognized operating system')
    }
  }
}
