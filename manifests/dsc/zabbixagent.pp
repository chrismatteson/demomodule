class demomodule::dsc::zabbixagent (

) {

  package { 'zabbix-agent':
    ensure   => present,
    provider => 'chocolatey',
  }

# Example with dsc
#  dsc_package { 'zabbix-agent':
#    dsc_ensure    => present,
#    dsc_path      => 'c:\zabbixagent.msi',
#    dsc_productid => 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'
#  }

  dsc_service { 'zabbix-agent':
    dsc_state        => 'running',
    dsc_startuptype  => 'automatic',
    require          => Package['zabbix-agent'],
  }
}
