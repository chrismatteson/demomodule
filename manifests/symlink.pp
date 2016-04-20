class demomodule::symlink (
$binaries = ["facter", "hiera", "mco", "puppet", "puppetserver"]
) {

# function call with lambda:
  $binaries.each |String $binary| {
    file {"/usr/bin/$binary":
      ensure => link,
      target => "/opt/puppetlabs/bin/$binary",
    }
  }
}
