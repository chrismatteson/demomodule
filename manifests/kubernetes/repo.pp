class demomodule::kubernetes::repo {

  yumrepo { 'virt7-docker-common-release':
    enabled  => 1,
    baseurl  => 'http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os',
    gpgcheck => 0,
  }
}
