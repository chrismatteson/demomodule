class demomodule::webblog::config {
  file { '/var/www/html':
    ensure => 'link',
    target => '/opt/wordpress',
    force  => true,
  }
  file { '/opt/wordpress/wp-content/plugins/blogger-importer/':
    ensure  => directory,
    source  => "puppet:///modules/demomodule/blogger-importer",
    recurse => true,
  }
  file { '/tmp/create_wordpress_db.erb':
     ensure => file,
     content => template('demomodule/create_wordpress_db.erb'),
     before => Exec [ '/usr/bin/mysql -u root  < /tmp/create_wordpress_db.erb' ],
  }
    exec { '/usr/bin/mysql -u root  < /tmp/create_wordpress_db.erb': }
}
