class demomodule::dsc::rdp (
  $rdp_setting = 1,
  $rdp_nla_setting = 1,
) {

  dsc_registry { 'RDP Setting':
    dsc_ensure    => present,
    dsc_key       => 'HKLM\System\CurrentControlSet\Control\Terminal Server',
    dsc_valuename => 'fDenyTSConnections',
    dsc_valuetype => 'dword',
    dsc_valuedata => $rdp_setting,
  }

  dsc_registry { 'RDP NLA Setting':
    dsc_ensure    => present,
    dsc_key       => 'HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp',
    dsc_valuename => 'UserAuthentication',
    dsc_valuetype => 'dword',
    dsc_valuedata => $rdp_nla_setting,
  }

  dsc_xfirewall { 'Allow RDP':
    dsc_ensure      => present,
    dsc_direction   => 'in',
    dsc_action      => 'allow',
    dsc_access      => 'permit',
    dsc_localport   => '3389',
    dsc_protocal    => 'TCP',
    dsc_displayname => 'Remote Desktop - Puppet',
    dsc_description => 'This exception allows RDP access (TCP 3389)',
  }
}

