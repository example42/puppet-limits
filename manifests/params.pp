# Class: limits::params
#
# Defines all the variables used in the module.
#
class limits::params {

  $package_name = $::osfamily ? {
    default => 'limits',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/limits/limits.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/limits',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
