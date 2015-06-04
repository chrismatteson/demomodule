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
  file_line { 'change default':
    ensure  => 'present',
    path    => '/opt/puppet/lib/ruby/site_ruby/1.9.1/puppet/util/nagios_maker.rb',
    line    => 'target = "/etc/nagios/conf.d/#{full_name.to_s}.cfg"',
    match   => 'target = "/etc/nagios/',
  }
  Class['epel'] ->
  package { 'nagios':
    ensure => 'present',
  } ->
  file { '/etc/nagios/objects/commands.cfg':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/commands.cfg",
    mode   => '0644',
  } ->
  service { 'nagios':
    ensure => 'running',
  }

  contain epel
  contain demomodule::nagios_common

  file { '/var/www/html/nagios':
    ensure  => 'link',
    target  => '/usr/share/nagios/html',
    require => Package['nagios'],
  }

  file { '/usr/share/nagios/html/cgi-bin':
    ensure => 'link',
    target => '/usr/lib64/nagios/cgi-bin',
    require => Package['nagios'],
  }

  file { '/etc/httpd/conf.d/cgi.conf':
    ensure  => 'file',
    content => 'ScriptAlias /nagios/cgi-bin /usr/lib64/nagios/cgi-bin/',
  }

  file_line { 'disable auth':
    ensure  => 'present',
    path    => '/etc/nagios/cgi.cfg',
    line    => 'use_authentication=0',
    match   => '^use_authentication=',
    require => Package['nagios'],
  }

  Nagios_host <<| |>> {
    target  => '/etc/nagios/conf.d/nagios_host.cfg',
    mode    => '0644',
    require => Class['demomodule::nagios_common'],
    notify  => Service['nagios'],
  }
  Nagios_service <<| |>> {
    target  => '/etc/nagios/conf.d/nagios_service.cfg',
    mode    => '0644',
    require => Class['demomodule::nagios_common'],
    notify  => Service['nagios'],
  }
  Nagios_hostextinfo <<| |>> {
    target  => '/etc/nagios/conf.d/nagios_hostextinfo.cfg',
    mode    => '0644',
    require => Class['demomodule::nagios_common'],
    notify  => Service['nagios'],
  }
  resources { ['nagios_host', 'nagios_service', 'nagios_hostextinfo']:
    purge  => 'true',
    notify => Service['nagios'],
    tag    => 'puppet',
  }

  firewall { '100 allow http':
    port => 80,
    proto => tcp,
    action => 'accept',
  }
}
