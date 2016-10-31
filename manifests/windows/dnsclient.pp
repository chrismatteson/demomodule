# ## Class: dnsclient ##
#
define demomodule::windows::dnsclient (
  $nameservers                 = [ '8.8.8.8',
                                  '8.8.4.4' ],
  $domain                      = 'UNSET',
) {

  if $::kernel == 'windows' {
    if is_array($nameservers) {
      $stringifynameservers = join($nameservers,',')
      $testserver = $nameservers[0]
    }
    else {
      $stringifynameservers = $nameservers
      $testserver = $nameservers
    }
    exec { 'set dns':
      command  => "\$interface = find-netroute -RemoteIPAddress ${testserver} | select -expand 'InterfaceAlias'; set-dnsclientserveraddress -interfacealias \$interface -serveraddress {${stringifynameservers}}",
      provider => powershell,
      unless   => "\$interface = find-netroute -RemoteIPAddress ${testserver} | select -expand 'InterfaceAlias'; \$currentdns = (get-dnsclientserveraddress -interfacealias \$interface | select -expand 'ServerAddresses') -join ','; if (\$currentdns -ne '${stringifynameservers}') { exit 1 }",
    }
  }
  elsif $::kernel == 'linux' {
    # Validates domain
    if is_domain_name($domain) != true {
      fail("Domain name, ${domain}, is invalid.")
    }

    # Validates $resolver_config_file_ensure
    case $resolver_config_file_ensure {
      'file', 'present', 'absent': {
        # noop, these values are valid
      }
      default: {
        fail("Valid values for \$resolver_config_file_ensure are \'absent\', \'file\', or \'present\'. Specified value is ${resolver_config_file_ensure}")
      }
    }

    file { 'dnsclient_resolver_config_file':
      ensure  => $resolver_config_file_ensure,
      content => template('dnsclient/resolv.conf.erb'),
      path    => $resolver_config_file,
      owner   => $resolver_config_file_owner,
      group   => $resolver_config_file_group,
      mode    => $resolver_config_file_mode,
    }
  }
  else {
    fail("Unsupported operating system ${::kernel}")
  }
}
