class demomodule::pdbquery {

  $resource = query_resources(false, 'Class["puppet_enterprise"]', false)
  notify { 'resources':
    message => $resource
  }

}
