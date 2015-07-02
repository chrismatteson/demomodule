class demomodule::profile::oracle::db (
  $oracle_disk1_location = 'http://download.oracle.com/otn/linux/oracle12c/121010/linuxamd64_12c_database_1of2.zip',
  $oracle_disk2_location = 'http://download.oracle.com/otn/linux/oracle12c/121010/linuxamd64_12c_database_2of2.zip',

  # global oracle vars
  $oracle_base_dir ='/oracle',
  $oracle_home_dir ='/oracle/product/12.1/db',

  # global OS vars
  $oracle_os_user = 'oracle',
  $oracle_os_group = 'dba',
  $oracle_download_dir = '/var/tmp/install',
  $oracle_source = '/software',
  $oracle_database_name = 'emrepos',
  $oracle_database_domain_name = 'example.com',
  $oracle_database_service_name = 'emrepos.example.com',
  $oracle_database_host = 'emrepos.example.com:1521',
  $oracle_database_sys_password = 'Welcome01',
  $oracle_database_system_password = 'Welcome01',
  ){

  $groups = ['oinstall','dba' ,'oper' ]

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
              'gcc-c++.x86_64','glibc-devel.x86_64','libaio-devel.x86_64','libstdc++-devel.x86_64',
              'sysstat.x86_64','unixODBC-devel','glibc.i686','libXext.x86_64','libXtst.x86_64','xorg-x11-xauth']


  package { $install:
    ensure  => present,
  }

  staging::file { 'linuxamd64_12c_database_1or2.zip':
    source => $oracle_disk1_location,
    target => $oracle_download_dir,
  }
  staging::file { 'linuxamd64_12c_database_2of2.zip':
    source => $oracle_disk2_location,
    target => $oracle_download_dir,
  }

  oradb::installdb{ '12.1.0.1_Linux-x86-64':
    version                => '12.1.0.1',
    file                   => 'linuxamd64_12c_database',
    databaseType           => 'EE',
    oracleBase             => $oracle_base_dir,
    oracleHome             => $oracle_home_dir,
    userBaseDir            => '/home',
    createUser             => false,
    bashProfile            => false,
    user                   => $oracle_os_user,
    group                  => $oracle_os_group,
    group_install          => 'oinstall',
    group_oper             => 'oper',
    downloadDir            => $oracle_download_dir,
    remoteFile             => false,
    puppetDownloadMntPoint => $oracle_source,
    require                => Staging::File['linuxamd64_12c_database_1of2.zip','linuxamd64_12c_database_2of2.zip'],
  }

  oradb::net{ 'config net8':
    oracleHome   => $oracle_home_dir,
    version      => '12.1',
    user         => $oracle_os_user,
    group        => $oracle_os_group,
    downloadDir  => $oracle_download_dir,
    require      => Oradb::Installdb['12.1.0.1_Linux-x86-64'],
  }

  oradb::listener{'start listener':
    oracleBase   => $oracle_base_dir,
    oracleHome   => $oracle_home_dir,
    user         => $oracle_os_user,
    group        => $oracle_os_group,
    action       => 'start',
    require      => Oradb::Net['config net8'],
  }

  oradb::database{ 'oraDb':
    oracleBase              => $oracle_base_dir,
    oracleHome              => $oracle_home_dir,
    version                 => '12.1',
    user                    => $oracle_os_user,
    group                   => $oracle_os_group,
    downloadDir             => $oracle_download_dir,
    action                  => 'create',
    dbName                  => $oracle_database_name,
    dbDomain                => $oracle_database_domain_name,
    sysPassword             => $oracle_database_sys_password,
    systemPassword          => $oracle_database_system_password,
    dataFileDestination     => "/oracle/oradata",
    recoveryAreaDestination => "/oracle/flash_recovery_area",
    characterSet            => "AL32UTF8",
    nationalCharacterSet    => "UTF8",
    emConfiguration         => 'NONE',
    memoryTotal             => '2500',
    sampleSchema            => 'FALSE',
    databaseType            => "MULTIPURPOSE",
    require                 => Oradb::Listener['start listener'],
  }

  oradb::dbactions{ 'start oraDb':
    oracleHome              => $oracle_home_dir,
    user                    => $oracle_os_user,
    group                   => $oracle_os_group,
    action                  => 'start',
    dbName                  => $oracle_database_name,
    require                 => Oradb::Database['oraDb'],
  }

  oradb::autostartdatabase{ 'autostart oracle':
    oracleHome              => $oracle_home_dir,
    user                    => $oracle_os_user,
    dbName                  => $oracle_database_name,
    require                 => Oradb::Dbactions['start oraDb'],
  }

  ora_init_param{ 'SPFILE/OPEN_CURSORS@emrepos':
    ensure => 'present',
    value  => '600',
  }

  ora_init_param{ 'SPFILE/processes@emrepos':
    ensure => 'present',
    value  => '1000',
  }

  ora_init_param{'SPFILE/job_queue_processes@emrepos':
    ensure  => present,
    value   => '20',
  }

  ora_init_param{'SPFILE/session_cached_cursors@emrepos':
    ensure  => present,
    value   => '200',
  }

  ora_init_param{'SPFILE/db_securefile@emrepos':
    ensure  => present,
    value   => 'PERMITTED',
  }

  ora_init_param{'SPFILE/memory_target@emrepos':
    ensure  => present,
    value   => '3000M',
  }

  ora_init_param { 'SPFILE/PGA_AGGREGATE_TARGET@emrepos':
    ensure  => 'present',
    value   => '1G',
    require => Ora_init_param['SPFILE/memory_target@emrepos'],
  }

  ora_init_param { 'SPFILE/SGA_TARGET@emrepos':
    ensure  => 'present',
    value   => '1200M',
    require => Ora_init_param['SPFILE/memory_target@emrepos'],
  }
  ora_init_param { 'SPFILE/SHARED_POOL_SIZE@emrepos':
    ensure  => 'present',
    value   => '600M',
    require => Ora_init_param['SPFILE/memory_target@emrepos'],
  }

  db_control{'emrepos restart':
    ensure                  => 'running', #running|start|abort|stop
    instance_name           => $oracle_database_name,
    oracle_product_home_dir => $oracle_home_dir,
    os_user                 => $oracle_os_user,
    refreshonly             => true,
    subscribe               => [Ora_init_param['SPFILE/OPEN_CURSORS@emrepos'],
                                Ora_init_param['SPFILE/processes@emrepos'],
                                Ora_init_param['SPFILE/job_queue_processes@emrepos'],
                                Ora_init_param['SPFILE/session_cached_cursors@emrepos'],
                                Ora_init_param['SPFILE/db_securefile@emrepos'],
                                Ora_init_param['SPFILE/SGA_TARGET@emrepos'],
                                Ora_init_param['SPFILE/SHARED_POOL_SIZE@emrepos'],
                                Ora_init_param['SPFILE/PGA_AGGREGATE_TARGET@emrepos'],
                                Ora_init_param['SPFILE/memory_target@emrepos'],],
  }
}
