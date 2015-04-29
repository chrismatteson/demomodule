class demomodule::nagios_target {

  @@nagios_host { $fqdn:
    ensure  => 'present',
    alias   => $hostname,
    address => $ipaddress_eth1,
    use     => 'generic-host',
  }

  @@nagios_hostextinfo { $fqdn:
    ensure          => 'present',
    icon_image_alt  => $operatingsystem,
    icon_image      => "base/$operatingsystem.png",
    statusmap_image => "base/$operatingsystem.gd2",
  }

  @@nagios_service { "check_ping_${hostname}":
    use       => 'check_ping',
    host_name => $fqdn,
  }

  @@nagios_service { "check_users_${hostname}":
    use       => 'remote-nrpe-users',
    host_name => $fqdn,
  }

  @@nagios_service { "check_load_${hostname}":
    use       => 'remote-nrpe-load',
    host_name => $fqdn,
  }

  @@nagios_service { "check_zombie_procs_${hostname}":
    use       => 'remote-nrpe-zombie-procs',
    host_name => $fqdn,
  }

  @@nagios_service { "check_total_procs_${hostname}":
    use       => 'remote-nrpe-total-procs',
    host_name => $fqdn,
  }

  @@nagios_service { "check_swap_${hostname}":
    use       => 'remote-nrpe-swap',
    host_name => $fqdn,
  }

  @@nagios_service { "check_all_disks_${hostname}":
    use       => 'remote-nrpe-all-disks',
    host_name => $fqdn,
  }
}
