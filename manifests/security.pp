class demomodule::security (
  $auditsetting = 'Failure,Success',
  $logonusers = 'BUILTIN_ADMINISTRATORS,BUILTIN_USERS,BACKUP_OPERATORS,TEST_USERS',
  $rasautoensure = 'running',
  $rasautoenable = true,
) {

  local_security_policy { 'Audit privilege use':
    ensure       => present,
    policy_value => $auditsetting,
  }

#  local_group_policy { 'System Audit Policies':
#    ensure => present,
#    policy_settings => {
#    }
#  }

  local_security_policy { 'Allow log on locally':
    ensure       => present,
    policy_value => $logonusers,
  }

  service { 'RasAuto':
    ensure => $rasautoensure,
    enable => $rasautoenable,
  }
}
