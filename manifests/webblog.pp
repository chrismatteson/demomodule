class demomodule::webblog {
  include apache
  include apache::mod::php
  contain epel
  contain mysql::server
  class { 'mysql::client':
    bindings_enable => true,
  }
  contain mysql::client 
  package { 'wget':
    ensure => '1.12-5.el6_6.1',
  }
  contain wordpress
  contain demomodule::webblog::config
}
