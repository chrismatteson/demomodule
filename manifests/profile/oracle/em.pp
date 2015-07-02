class demomodule::profile::oracle::em {

 $groups = ['oinstall']

  group { $groups :
    ensure      => present,
  }

  user { 'oracle' :
    ensure      => present,
    uid         => 500,
    gid         => 'oinstall',
    groups      => $groups,
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/oracle",
    comment     => "This user oracle was created by Puppet",
    require     => Group[$groups],
    managehome  => true,
  }

  $install = ['binutils.x86_64', 'compat-libstdc++-33.x86_64', 'glibc.x86_64','ksh.x86_64','libaio.x86_64',
              'libgcc.x86_64', 'libstdc++.x86_64', 'make.x86_64','compat-libcap1.x86_64', 'gcc.x86_64',
              'gcc-c++.x86_64','glibc-devel.x86_64','glibc-devel.i686','libaio-devel.x86_64','libstdc++-devel.x86_64',
              'sysstat.x86_64','unixODBC-devel','glibc.i686','libXext.x86_64','libXtst.x86_64','xorg-x11-xauth']


  package { $install:
    ensure  => present,
  }

  oradb::installem{ 'em12104':
    version                     => '12.1.0.4',
    file                        => 'em12104_linux64',
    oracle_base_dir             => '/oracle',
    oracle_home_dir             => '/oracle/product/12.1/em',
    agent_base_dir              => '/oracle/product/12.1/agent',
    software_library_dir        => '/oracle/product/12.1/swlib',
    weblogic_user               => 'weblogic',
    weblogic_password           => 'Welcome01',
    database_hostname           => 'emdb.example.com',
    database_listener_port      => 1521,
    database_service_sid_name   => 'emrepos.example.com',
    database_sys_password       => 'Welcome01',
    sysman_password             => 'Welcome01',
    agent_registration_password => 'Welcome01',
    deployment_size             => 'SMALL',
    user                        => 'oracle',
    group                       => 'oinstall',
    download_dir                => '/install',
    zip_extract                 => true,
    puppet_download_mnt_point   => '/software',
    remote_file                 => false,
    log_output                  => true,
  }

}
