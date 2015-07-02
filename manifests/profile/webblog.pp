class demomodule::profile::webblog {
  include apache
  include apache::mod::php
  contain epel
  contain mysql::server
  class { 'mysql::client':
    bindings_enable => true,
  }
  contain mysql::client 
  contain wordpress

  Class['epel'] ->
  Class['mysql::server'] ->
  Class['mysql::client'] ->
  package { 'wget':
    ensure => '1.12-5.el6_6.1',
  } ->
  Class['wordpress']

  @@nagios_service { "check_http_${hostname}":
    use                 => 'local-service',
    service_description => 'http',
    check_command       => 'check_http',
    host_name           => $fqdn,
  }

  @@nagios_service { "check_http_processes_${hostname}":
    use       => 'local-service',
    service_description => 'check httpd procs',
    check_command => 'check_nrpe!check_httpd_procs',
    host_name => $fqdn,
  }

  file { '/var/www/html':
    ensure => 'link',
    target => '/opt/wordpress',
    force  => true,
  }
  file { '/tmp/create_wordpress_db.erb':
     ensure => file,
     content => template('demomodule/create_wordpress_db.erb'),
     before => Exec [ '/usr/bin/mysql -u root  < /tmp/create_wordpress_db.erb; touch /tmp/mysqlloaded' ],
  }
  exec { '/usr/bin/mysql -u root  < /tmp/create_wordpress_db.erb; touch /tmp/mysqlloaded':
    creates => '/tmp/mysqlloaded',
    require => Class['wordpress'],
  }

  firewall { '100 allow http':
    port => 80,
    proto => tcp,
    action => 'accept',
  }
}
