class demomodule::docker {
  require ::docker

  docker::image { 'ubuntu':
    image_tag => 'trusty',
  }

  docker::run { 'helloworld':
    image   => 'ubuntu',
    command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  }

  docker::run { 'goodbyecruelworld':
    image   => 'ubuntu',
    command => '/bin/sh -c "while true: do echo goodbye cruel world; sleep 1; done"',
  }
}
