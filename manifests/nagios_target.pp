class demomodule::nagios_target {

  include demomodule::nagios_common

  @@nagios_host { $fqdn:
    ensure  => 'present',
    alias   => $hostname,
    address => $ipaddress_eth1,
    use     => 'linux-server',
  }

  @@nagios_hostextinfo { $fqdn:
    ensure          => 'present',
    icon_image_alt  => $operatingsystem,
    icon_image      => "base/$operatingsystem.png",
    statusmap_image => "base/$operatingsystem.gd2",
  }

  @@nagios_service { "check_ping_${hostname}":
    use                 => 'local-service',
    service_description => 'ping',
    check_command       => 'check_ping!200.0,70%!400.0,90%',
    host_name           => $fqdn,
  }

  @@nagios_service { "check_users_${hostname}":
    use                  => 'local-service',
    service_description => 'check users',
    check_command       => 'check_nrpe!check_users',
    host_name            => $fqdn,
  }

  @@nagios_service { "check_load_${hostname}":
    use       => 'local-service',
    service_description => 'check load',
    check_command => 'check_nrpe!check_load',
    host_name => $fqdn,
  }

  @@nagios_service { "check_zombie_procs_${hostname}":
    use       => 'local-service',
    service_description => 'check zombie procs',
    check_command => 'check_nrpe!check_zombie_procs',
    host_name => $fqdn,
  }

  @@nagios_service { "check_total_procs_${hostname}":
    use       => 'local-service',
    service_description => 'check total procs',
    check_command => 'check_nrpe!check_total_procs',
    host_name => $fqdn,
  }

  @@nagios_service { "check_swap_${hostname}":
    use       => 'local-service',
    service_description => 'check swap',
    check_command => 'check_nrpe!check_swap',
    host_name => $fqdn,
  }

  @@nagios_service { "check_all_disks_${hostname}":
    use       => 'local-service',
    service_description => 'check all disks',
    check_command => 'check_nrpe!check_all_disks',
    host_name => $fqdn,
  }
}
