class demomodule::profile::base (
  $nameservers = ['4.2.2.2', '8.8.8.8'],
) {

  class { 'dnsclient':
    nameservers => $nameservers,
  }

  include sudo

  group { 'admins':
    ensure => present,
  }

  user { 'vagrant':
    groups => 'admins',
  }
}
