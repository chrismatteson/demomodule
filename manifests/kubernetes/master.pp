class demomodule::kubernetes::master {

  package { ['etcd','kubernetes-master','flannel']:
    ensure => installed,
  }

  class { 'demomodule::kubernetes::etcd_config':
    require => Package['etcd'],
    notify  => Service['etcd'],
  }

  service { ['etcd','flanneld','kube-apiserver','kube-controller-manager','kube-scheduler']:
    enable => true,
    ensure => running,
  }

  file { '/tmp/flannel-config.json':
    ensure => file,
    source => 'puppet:///modules/demomodule/flannel-config.json',
    require => Package['flannel'],
  }

  exec { '/bin/etcdctl set coreos.com/network/config < /etc/flannel-config.json':
    refreshonly => true,
    subscribe   => File['/tmp/flannel-config.json'],
    notify      => Service['flanneld'],
  }

  file_line { 'FLANNEL_ETCD':
    path   => '/etc/etcd/etcd.conf',
    ensure => present,
    match  => '^FLANNEL_ETCD=',
    line   => 'FLANNEL_ETCD="http://kube-master:2379"',
    notify => Service['flanneld'],
  }
}
