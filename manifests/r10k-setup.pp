class demomodule::r10k-setup {

  class { 'r10k':
    remote => 'git@github.com:chrismatteson/seteam-puppet-environments.git',
  }

  class { 'r10k::webhook::config':
    enable_ssl => false,
    protected  => false,
    notify     => Service['webhook'],
  }

  class { 'r10k::webhook':
    require => Class['r10k::webhoot::config']
  }
}
