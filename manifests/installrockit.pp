# jrockit::instalrockit

define jrockit_jdk::installrockit (
  $version        =  undef,
  $x64            =  undef,
  $download_dir    =  '/install/',
  $puppet_mount_dir =  undef,
  $install_demos   =  false,
  $install_source  =  false,
  $install_jre     =  true,
  $set_default     =  true,
  $jre_install_dir  =  '/usr/java',
  $install_dir     = undef,
  ) {

  $full_version   =  "jrockit-jdk${version}"

  if $install_dir == undef {
    $install_dir = "${jre_install_dir}/${full_version}"
  }

  notify {"installrockit.pp ${title} ${version}":}

  if $x64 == true {
    $type = 'x64'
  }
  else {
    $type = 'ia32'
  }

  case $::operatingsystem {
    CentOS, RedHat, OracleLinux, Ubuntu, Debian: {
      $install_version   = 'linux'
      $install_extension = '.bin'
      $user             = 'root'
      $group            = 'root'
    }
    windows: {
      $install_version   = 'windows'
      $install_extension = '.exe'
    }
    default: {
      fail('Unrecognized operating system')
    }
  }

  $jdkfile =  "jrockit-jdk${version}-${install_version}-${type}${install_extension}"

  File {
    replace => false,
  }

  # check install folder
  if ! defined(File[$download_dir]) {
    file { $download_dir :
      ensure => directory,
      mode   => '0777',
      path   => $download_dir,
    }
  }

  # if a mount was not specified then get the install media from the puppet master
    if $puppet_mount_dir == undef {
      $mountDir = 'puppet:///modules/jrockit/'
    }
    else {
      $mountDir = $puppet_mount_dir
    }

  # download jdk to client
  if ! defined(File["${download_dir}/${jdkfile}"]) {
    file {"${download_dir}/${jdkfile}":
      ensure  => present,
      path    => "${download_dir}/${jdkfile}",
      source  => "${mountDir}/${jdkfile}",
      require => File[$download_dir],
      mode    => '0755',
    }
  }

  # install on client
  javaexec {"jdkexec ${title} ${version}":
    path            => $download_dir,
    full_version    => $full_version,
    version         => $version,
    jdkfile         => $jdkfile,
    set_default     => $set_default,
    user            => $user,
    group           => $group,
    jre_install_dir => $install_dir,
    require         => File["${download_dir}/${jdkfile}"],
  }
}
