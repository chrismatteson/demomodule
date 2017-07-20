class demomodule::cron (
  $croncommand = 'test -f /var/tmp/pause-puppet || (/opt/puppetlabs/puppet/bin/refresh-mcollective-metadata >>/var/log/puppetlabs/mcollective-metadata-cron.log 2>&1)'
) {

  Cron <| title == 'pe-mcollective-metadata' |> {
    command => $croncommand,
  }
}
