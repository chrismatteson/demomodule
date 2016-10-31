class demomodule::windows::dc (
  $developers = hiera_hash('demomodule::windows::deveoperss_hash', $demomodule::windows::params::developers)
) inherits demomodule::windows::params {

  class {'windows_ad':
    install                => 'present',
    installmanagementtools => true,
    restart                => true,
    installflag            => true,
    configure              => 'present',
    configureflag          => true,
    domain                 => 'forest',
    domainname             => 'windowsdemo.local',
    netbiosdomainname      => 'windowsdemo',
    domainlevel            => '6',
    forestlevel            => '6',
    databasepath           => 'c:\\windows\\ntds',
    logpath                => 'c:\\windows\\ntds',
    sysvolpath             => 'c:\\windows\\sysvol',
    installtype            => 'domain',
    dsrmpassword           => 'PuppetLabs!',
    installdns             => 'yes',
    localadminpassword     => 'PuppetLabs!',
  }

  windows_ad::user { 'joindomain':
    accountname  => 'joindomain',
    firstname    => 'join',
    lastname     => 'domain',
    path         => 'CN=Users,DC=WINDOWSDEMO,DC=LOCAL',
    password     => 'PuppetLab5!',
    domainname   => 'windowsdemo.local',
  }

  windows_ad::groupmembers { 'joindomain':
    ensure    => 'present',
    groupname => 'Domain Admins',
    members   => 'joindomain',
    require   => Windows_ad::User['joindomain'],
  }

  Windows_ad::User {
    path       => 'CN=Users,DC=WINDOWSDEMO,DC=LOCAL',
    domainname => 'windowsdemo.local',
  }

  create_resources(windows_ad::user, $developers)

  windows_ad::group {'developers':
    ensure        => 'present',
    displayname   => 'developers',
    path          => 'CN=Users,DC=WINDOWSDEMO,DC=LOCAL',
    groupname     => 'developers',
    groupscope    => 'Global',
    groupcategory => 'Security',
  }

  $developersarray = keys($developers)
  $developersslist = join($developersarray, ',')

  windows_ad::groupmembers { 'developers':
    ensure    => 'present',
    groupname => 'developers',
    members   => $studentslist,
    require   => Windows_ad::Group['developers'],
  }

  @@demomodule::windows::dnsclient { $fqdn:
    nameservers => $ipaddress,
  }
 
  Demomodule::Windows::Dnsclient <<| |>>

  @@host { $fqdn:
    ensure       => 'present',
    host_aliases => $hostname,
    ip           => $ipaddress,
  }

  Host <<| |>>

}
