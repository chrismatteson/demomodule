class demomodule::rdp {

  dsc_registry { 'rdp':
    dsc_key => 'HKLM\System\CurrentControlSet\Control\Terminal Server',
    dsc_valuename => 'UserAuthentication',
    dsc_valuetype => 'dword',
    dsc_valuedata => '1',
    dsc_ensure => present,
  }
}
