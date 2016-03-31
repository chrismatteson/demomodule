class demomodule::dsc::windowsfeature {

  dsc_windowsfeature {'IIS':
    dsc_ensure => 'present',
    dsc_name   => 'Web-Server',
  }
}
