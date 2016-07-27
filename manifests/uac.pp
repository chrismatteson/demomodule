class demomodule::uac {

  registry_value { 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA':
    ensure => present,
    type   => dword,
    data   => 1,
  }

  registry_value { 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin':
    ensure => present,
    type   => dword,
    data   => 1,
  }
}
