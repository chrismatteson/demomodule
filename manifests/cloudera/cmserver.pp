class demomodule::cloudera::cmserver {

  host { $fqdn:
    ip           => '127.0.1.1',
    host_aliases => $hostname,
  } ->
  class { 'cloudera':
    cm_server_host   => $fqdn,
    install_cmserver => true,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
}
