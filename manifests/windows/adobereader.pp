class demomodule::windows::adobereader {

  package {'adobereader':
    ensure    => latest,
    provider => 'chocolatey',
  }
}
