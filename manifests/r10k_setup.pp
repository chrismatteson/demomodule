class demomodule::r10k_setup {

  class { 'r10k':
    remote => 'git@github.com:chrismatteson/seteam-puppet-environments.git',
  }

  class { 'r10k::webhook::config':
    protected       => false,
    use_mcollective => false,
  }

  class { 'r10k::webhook':
    user      => 'root',
    group     => '0',
    require   => Class['r10k::webhook::config'],
  }

#  git_webhook { 'web_post_receive_webhook':
#    ensure       => 'present',
#    webhook_url  => 'http://52.24.239.35:8088/payload',
#    token        => '8ce554193cc933072433917975b67dca624ac4c0',
#    project_name => 'chrismatteson/seteam-puppet-environments',
#    server_url   => 'https://api.github.com/',
#    disable_ssl_verify => true,
#    provider     => 'github',
#  }

#  git_deploy_key { 'add_deploy_key_to_puppet_control':
#    ensure       => 'present',
#    name         => $::fqdn,
#    path         => '/root/.ssh/id_dsa.pub',
#    token        => '8ce554193cc933072433917975b67dca624ac4c0',
#    server_url   => 'https://api.github.com/',
#    provider     => 'github',
#  }
}
