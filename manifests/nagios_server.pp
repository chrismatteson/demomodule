class demomodule::nagios_server {

  include apache
  include apache::mod::php
  Class['epel'] ->
  package { ['nagios', 'nagios-plugins-all', 'nagios-plugins-nrpe', 'nrpe']:
    ensure => 'present',
  }
  contain epel

  service { 'nagios':
    ensure => 'running',
  }

  Nagios_host <<||>>
  Nagios_service <<||>>
  Nagios_hostextinfo <<||>>

}
