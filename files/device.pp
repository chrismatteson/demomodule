
## device.pp ##

# This file is used to declare device configurations for devices which are
# configured in the /etc/puppetlabs/puppet/devices.conf file.

# This file is created and managed by chrismatteson/demomodule

node 'csr1000v' {
  interface { 'GigabitEthernet1':
    description => 'Managed by Puppet',
  }
}
