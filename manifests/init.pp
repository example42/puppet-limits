#
# = Class: limits
#
# This class installs and manages limits
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class limits (

  $package_name             = $limits::params::package_name,
  $package_ensure           = 'present',

  $config_file_path         = $limits::params::config_file_path,
  $config_file_owner        = $limits::params::config_file_owner,
  $config_file_group        = $limits::params::config_file_group,
  $config_file_mode         = $limits::params::config_file_mode,
  $config_file_require      = undef,
  $config_file_replace      = undef,
  $config_file_source       = undef,
  $config_file_template     = undef,
  $config_file_content      = undef,
  $config_file_options_hash = { },

  $config_dir_path          = $limits::params::config_dir_path,
  $config_dir_source        = undef,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,

  $dependency_class         = undef,
  $my_class                 = undef,

  ) inherits limits::params {

  # Class variables validation and management
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  if $package_ensure == 'absent' {
    $config_dir_ensure  = 'absent'
    $config_file_ensure = 'absent'
  } else {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
  }

  # Dependency class
  if $dependency_class {
    include $dependency_class
  }

  # Resources managed
  package { 'limits':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if $config_file_path {
    file { 'limits.conf':
      ensure  => $config_file_ensure,
      path    => $config_file_path,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $manage_config_file_content,
      require => $config_file_require,
    }
  }

  if $config_dir_source {
    file { 'limits.dir':
      ensure  => $config_dir_ensure,
      path    => $config_dir_path,
      source  => $config_dir_source,
      recurse => $config_dir_recurse,
      purge   => $config_dir_purge,
      force   => $config_dir_purge,
      require => $config_file_require,
    }
  }

  # Extra classes
  if $my_class {
    include $my_class
  }
}
