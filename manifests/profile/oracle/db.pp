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
  $oracle_source = '/var/tmp/install',
  $oracle_database_name = 'emrepos',
  $oracle_database_domain_name = 'pdx.puppetlabs.demo',
  $oracle_database_service_name = 'emrepos.pdx.puppetlabs.demo',
  $oracle_database_host = 'emrepos.pdx.puppetlabs.demo:1521',
  $oracle_database_sys_password = 'Welcome01',
  $oracle_database_system_password = 'Welcome01',
  ){

  $groups = ['oinstall','dba' ,'oper' ]

  group { $groups :
    ensure      => present,
  }

  file_line { 'tmpfs':
    path   => '/etc/fstab',
    line   => 'tmpfs                   /dev/shm                tmpfs   size=6g        0 0',
    match  => '^tmpfs                   /dev/shm                tmpfs',
    notify => Exec['remount tmpfs'],
  }

  exec { 'remount tmpfs':
    command     => '/bin/mount -o remount /dev/shm',
    refreshonly => true,
    before      => Oradb::Installdb['12.1.0.1_Linux-x86-64'],
  }

  user { 'oracle' :
    ensure      => present,
#    uid         => 500,
    gid         => 'oinstall',
    groups      => $groups,
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/oracle",
    comment     => "This user oracle was created by Puppet",
    require     => Group[$groups],
    managehome  => true,
  }

  $install = ['unzip','binutils.x86_64', 'compat-libstdc++-33.x86_64', 'glibc.x86_64','ksh.x86_64',
              'libaio.x86_64','libgcc.x86_64', 'libstdc++.x86_64', 'make.x86_64','compat-libcap1.x86_64',
              'gcc.x86_64','gcc-c++.x86_64','glibc-devel.x86_64','libaio-devel.x86_64','libstdc++-devel.x86_64',
              'sysstat.x86_64','unixODBC-devel','glibc.i686','libXext.x86_64','libXtst.x86_64','xorg-x11-xauth']


  package { $install:
    ensure  => present,
  }

  file { '/var/tmp/install':
    ensure => 'directory',
  }

  staging::file { 'linuxamd64_12c_database_1of2.zip':
    source  => $oracle_disk1_location,
    target  => "$oracle_download_dir/linuxamd64_12c_database_1of2.zip",
    require => File['/var/tmp/install'],
  }
  staging::file { 'linuxamd64_12c_database_2of2.zip':
    source => $oracle_disk2_location,
    target => "$oracle_download_dir/linuxamd64_12c_database_2of2.zip",
    require => File['/var/tmp/install'],
  }

  oradb::installdb{ '12.1.0.1_Linux-x86-64':
    version                => '12.1.0.1',
    file                   => 'linuxamd64_12c_database',
    database_type           => 'EE',
    oracle_base             => $oracle_base_dir,
    oracle_home             => $oracle_home_dir,
    user_base_dir            => '/home',
    bash_profile            => false,
    user                   => $oracle_os_user,
    group                  => $oracle_os_group,
    group_install          => 'oinstall',
    group_oper             => 'oper',
    download_dir            => $oracle_download_dir,
    remote_file             => false,
    puppet_download_mnt_point => $oracle_source,
    require                => Staging::File['linuxamd64_12c_database_1of2.zip','linuxamd64_12c_database_2of2.zip'],
  }

  oradb::net{ 'config net8':
    oracle_home   => $oracle_home_dir,
    version      => '12.1',
    user         => $oracle_os_user,
    group        => $oracle_os_group,
    download_dir  => $oracle_download_dir,
    require      => Oradb::Installdb['12.1.0.1_Linux-x86-64'],
  }

  oradb::listener{'start listener':
    oracle_base   => $oracle_base_dir,
    oracle_home   => $oracle_home_dir,
    user         => $oracle_os_user,
    group        => $oracle_os_group,
    action       => 'start',
    require      => Oradb::Net['config net8'],
  }

  oradb::database{ 'oraDb':
    oracle_base              => $oracle_base_dir,
    oracle_home              => $oracle_home_dir,
    version                 => '12.1',
    user                    => $oracle_os_user,
    group                   => $oracle_os_group,
    download_dir             => $oracle_download_dir,
    action                  => 'create',
    db_name                  => $oracle_database_name,
    db_domain                => $oracle_database_domain_name,
    sys_password             => $oracle_database_sys_password,
    system_password          => $oracle_database_system_password,
    data_file_destination     => "/oracle/oradata",
    recovery_area_destination => "/oracle/flash_recovery_area",
    character_set            => "AL32UTF8",
    nationalcharacter_set    => "UTF8",
    em_configuration         => 'NONE',
    memory_total             => '2500',
    sample_schema            => 'FALSE',
    database_type            => "MULTIPURPOSE",
    require                 => Oradb::Listener['start listener'],
  }

  oradb::dbactions{ 'start oraDb':
    oracle_home              => $oracle_home_dir,
    user                    => $oracle_os_user,
    group                   => $oracle_os_group,
    action                  => 'start',
    db_name                  => $oracle_database_name,
    require                 => Oradb::Database['oraDb'],
  }

  oradb::autostartdatabase{ 'autostart oracle':
    oracle_home              => $oracle_home_dir,
    user                    => $oracle_os_user,
    db_name                  => $oracle_database_name,
    require                 => Oradb::Dbactions['start oraDb'],
  }

  ora_init_param{ 'SPFILE/OPEN_CURSORS@emrepos':
    ensure  => 'present',
    value   => '600',
    require => Oradb::Autostartdatabase['autostart oracle'],
  }

  ora_init_param{ 'SPFILE/processes@emrepos':
    ensure => 'present',
    value  => '1000',
    require => Oradb::Autostartdatabase['autostart oracle'],
  }

  ora_init_param{'SPFILE/job_queue_processes@emrepos':
    ensure  => present,
    value   => '20',
    require => Oradb::Autostartdatabase['autostart oracle'],
  }

  ora_init_param{'SPFILE/session_cached_cursors@emrepos':
    ensure  => present,
    value   => '200',
    require => Oradb::Autostartdatabase['autostart oracle'],
  }

  ora_init_param{'SPFILE/db_securefile@emrepos':
    ensure  => present,
    value   => 'PERMITTED',
    require => Oradb::Autostartdatabase['autostart oracle'],
  }

  ora_init_param{'SPFILE/memory_target@emrepos':
    ensure  => present,
    value   => '3000M',
    require => Oradb::Autostartdatabase['autostart oracle'],
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
