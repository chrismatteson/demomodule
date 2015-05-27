class demomodule::exchangeprofile {

  class { 'dnsclient':
    nameservers => ['10.20.1.19'],
  }
  class { 'domain_membership':
    domain   => 'puppetlabs.demo',
    username => 'vagrant',
    password => 'vagrant',
  }
  class { 'exchange':
    acceptexchangeserverlicense => true,
  }

  Class['dnsclient'] ->
  Class['domain_membership'] ->
  Class['exchange']
}
