class demomodule::webblog {
  include apache
  include apache::mod::php
  contain epel
  contain mysql::server
  class { 'mysql::client':
    bindings_enable => true,
  }
  contain mysql::client 
  contain wordpress
  contain demomodule::webblog::config

  Class['epel'] ->
  Class['mysql::server'] ->
  Class['mysql::client'] ->
  package { 'wget':
    ensure => '1.12-5.el6_6.1',
  } ->
  Class['wordpress'] ->
  Class['demomodule::webblog::config']

  @@nagios_service { "check_http_${hostname}":
    use       => 'check-http',
    host_name => $fqdn,
  }

  @@nagios_service { "check_http_processes_${hostname}":
    use       => 'remote-nrpe-httpd-procs',
    host_name => $fqdn,
  }
}
