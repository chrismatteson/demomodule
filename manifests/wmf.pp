class demomodule::wmf {

  service { 'wuauserv':
    ensure => running,
    enable => true,
  }

  package { 'powershell':
    ensure   => present,
    provider => 'chocolatey',
    require  => Service['wuauserv'],
  }

  reboot { 'after':
    subscribe => Package['powershell'],
  }
}
