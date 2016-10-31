class demomodule::windows::adobereader {

  package {'adobereader':
    ensure    => latest,
    provider => 'chocolatey',
    install_options => '--allowemptychecksum',
  }
}
