class demomodule::rspec-puppet {

  package { ['rspec-puppet', 'puppetlabs_spec_helper']:
    ensure   => 'present',
    provider => 'gem',
  }
  file { '/etc/puppetlabs/puppet/environments/production/modules/ntp/.fixtures.yml':
    ensure => 'present',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/ntpfixtures.yml",
  }
  file { '/etc/puppetlabs/puppet/environments/production/modules/apache/.fixtures.yml':
    ensure => 'present',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/apachefixtures.yml",
  }
}
