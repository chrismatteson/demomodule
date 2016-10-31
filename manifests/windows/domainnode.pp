class demomodule::windows::domainnode {

  class { 'domain_membership':
    domain       => 'windowsdemo.local',
    username     => 'joindomain',
    password     => 'PuppetLab5!',
    join_options => '3',
  }
  contain domain_membership

  Demomodule::Windows::Dnsclient <<| |>> {
    before => Class['domain_membership'],
  }

  @@host { $fqdn:
    ensure       => 'present',
    host_aliases => [$hostname,$clientcert],
    ip           => $ipaddress,
  }

  Host <<| |>> {
  }
}
