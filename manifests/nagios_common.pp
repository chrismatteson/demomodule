class demomodule::nagios_common {

  Class['epel'] ->
  package { ['nrpe', 'nagios-plugins-all', 'nagios-plugins-nrpe']:
    ensure => 'present',
  } ->
  file { '/etc/nagios/nrpe.cfg':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/nrpe.cfg",
    mode   => '0644',
  } ~>
  service { 'nrpe':
    ensure => 'running',
    enable => true,
  }
  firewall { '300 allow nrpe':
    port => 5666,
    proto => tcp,
    action => 'accept',
  }

  contain epel

}
