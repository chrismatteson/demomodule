class demomodule::cisco {

  file { '/etc/puppetlabs/puppet/device.conf':
    ensure => 'file',
    source => 'puppet:///modules/demomodule/device.conf',
    mode   => 0644,
  }

  file { "/etc/puppetlabs/puppet/environments/${::environment}/manifests/device.pp":
    ensure => 'file',
    source => 'puppet:///modules/demomodule/device.pp',
    mode   => 0644,
  }

  file { '/opt/puppet/lib/ruby/site_ruby/1.9.1/puppet/util/network_device/cisco/facts.rb':
    ensure => 'file',
    source => 'puppet:///modules/demomodule/facts.rb',
    mode   => 0644,
  }
}
