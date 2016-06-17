class demomodule::azure (
#  $gempackages = {
#    azure:
#      ensure => '~>0.7.0',
#    azure_mgmt_compute:
#      ensure =>
#    
) {

  include ::azure

  azure_vm { 'test':
    ensure => present,
    location => 'eastus',
    image          => 'canonical:ubuntuserver:14.04.2-LTS:latest',
    user           => 'azureuser',
    password       => 'Password',
    size           => 'Standard_A0',
  }
}
