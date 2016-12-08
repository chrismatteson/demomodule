class demomodule::cloudera::slave (
  $cm_server_host
) {

  class { 'cloudera':
    cm_server_host => $cm_server_host,
  }
}
