# Run this script from the master
# /vagrant/scripts/setup_ds.sh
# to configure the sample DS.

PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"

curl -X GET -H 'Content-Type: application/json' \
--cacert `puppet config print localcacert` \
--cert   `puppet config print hostcert` \
--key    `puppet config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/nodes | python -m json.tool
