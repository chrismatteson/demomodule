class demomodule::user (
  $username,
  $password,
  ){
  
  user { "$username":
    ensure     => present,
    home       => "/home/$username",
    managehome => true,
    comment    => "$username account created and managed by puppet",
    forcelocal => true,
    groups     => 'sysadmins',
    shell      => '/bin/bash',
    password   => "$password",
  }

  file_line { "Puppet Path":
    ensure  => present,
    line    => 'PATH=$PATH:/opt/puppet/bin/',
    path    => "/home/$username/.bashrc",
    require => User["$username"],
  }

  group { 'sysadmins':
    ensure => present
  }
}
