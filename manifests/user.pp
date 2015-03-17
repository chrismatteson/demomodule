class demomodule::user (
  $username,
  $password = 'undef',
  $ensure = 'present',
  ){
  
  user { "$username":
    ensure     => $ensure,
    home       => "/home/$username",
    managehome => true,
    comment    => "$username account created and managed by puppet",
    forcelocal => true,
    groups     => 'sysadmins',
    shell      => '/bin/bash',
    password   => generate('/bin/sh','-c',"openssl passwd -1 ${password} | tr -d '\n'"),
  }

  file_line { "Puppet Path":
    ensure  => $ensure,
    line    => 'PATH=$PATH:/opt/puppet/bin/',
    path    => "/home/$username/.bashrc",
    require => User["$username"],
  }

  group { 'sysadmins':
    ensure => $ensure,
  }
}
