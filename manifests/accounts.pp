# This class wraps the puppetlabs/accounts module and the native
# group type to create accounts and groups from hiera.
#
# Enteries in Hiera should look like this:
#
# accounts_hash:
#   bob:
#     - uid: 4001
#     - gid: 4001
#     - shell: '/bin/bash'
#     - password: '!!'
#     - sshkeys: 'ssh-rsa AAAA...'
#     - locked: false
#   sue:
#     - uid: 4002
#     - gid: 4002
#     - shell: '/bin/ksh'
#     - password: '!!'
#     - sshkeys: 'ssh-rsa AAAA...'
#     - locked: false
class demomodule::accounts (
  $accounts = hiera_hash($accounts_hash),
  $groups = hiera_hash($groups_hash),
) {

  create_resources(accounts::user, $accounts)
  create_resources(group, $groups)

}
