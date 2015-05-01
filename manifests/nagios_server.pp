class demomodule::nagios_server (
  $myhost = {
    "${fqdn}" => {
      'port' => 8080,
      'protocol' => 'http',
      'tag' => 'MY',
    }
  }
  ) {

  include apache
  include apache::mod::php
  include apache::mod::cgi
  Class['epel'] ->
  package { ['nagios', 'nagios-plugins-all', 'nagios-plugins-nrpe', 'nrpe']:
    ensure => 'present',
  } ->
  service { 'nagios':
    ensure => 'running',
  }
  contain epel

  file { '/var/www/html/nagios':
    ensure => 'link',
    target => '/usr/share/nagios/html',
  }

  file { '/usr/share/nagios/html/cgi-bin':
    ensure => 'link',
    target => '/usr/lib64/nagios/cgi-bin',
  }

  file { '/etc/httpd/conf.d/cgi.conf':
    ensure  => 'file',
    content => 'ScriptAlias /nagios/cgi-bin /usr/lib64/nagios/cgi-bin/',
  }

  file_line { 'disable auth':
    ensure => 'present',
    path   => '/etc/nagios/cgi.cfg',
    line   => 'use_authentication=0',
    match  => '/use_authentication=/',
  }

  Nagios_host <<| |>>
  Nagios_service <<| |>>
  Nagios_hostextinfo <<| |>>

}
