class profiles::webblog {
  include apache
  include apache::mod::php
  class { 'wordpress' :
  }
  include mysql::server
  #  class { '::mysql::server':
  #  root_password => 'wordpress',
  #  databases => {
  #    'wordpress' => {
  #      ensure => 'present',
  #      charset => 'utf8',
  #    }
  #  },
  #  users => {
  #    'wordpress' => {
  #      ensure => present,
  #      password_has => mysql_password('wordpress'),
  #    }
  #  },
  #  grants => {
  #    'wordpress' => {
  #      ensure => present,
  #      options => ['GRANT'],
  #      privileges => ['ALL'],
  #      table => 'wordpress',
  #      user => 'wordpress@localhost'
  #    }
  #  },
  #}
  class { 'mysql::client':
    require => Class['mysql::server'],
    bindings_enable => true,
  }
  file { '/var/www/html/wp-content/plugins/blogger-importer/':
    ensure => directory,
    source => "puppet:///modules/demomodule/blogger-importer",
    recurse => true,
  }

  user { 'wordpress':
    ensure => 'present',
    password => 'wordpress',
  }

}
