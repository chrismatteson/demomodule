class demomodule::tsm (
  $backupserver
) {

#  exec { 'tsm install':
#    command => 'wget http://xxx/tsm/tsminstall.sh; ./tsminstall.sh',
#    creates => '/bin/tsm?'
#  }

  file { '/etc/dsm.sys':
    ensure  => present,
    content => template('demomodule/dsm.sys.erb'),
    mode    => '0644',
  }


  file { 'etc/dsm.opt':
    ensure  => present,
    content => template('demomodule/dsm.opt.erb'),
    mode    => '0644',
  }
}
