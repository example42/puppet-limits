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
  $config_file_require      = 'Package[limits]',
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
  if $limits::dependency_class {
    include $limits::dependency_class
  }

  # Resources managed
  if $limits::package_name {
    package { 'limits':
      ensure => $limits::package_ensure,
      name   => $limits::package_name,
    }
  }

  if $limits::config_file_path {
    file { 'limits.conf':
      ensure  => $limits::config_file_ensure,
      path    => $limits::config_file_path,
      mode    => $limits::config_file_mode,
      owner   => $limits::config_file_owner,
      group   => $limits::config_file_group,
      source  => $limits::config_file_source,
      content => $limits::manage_config_file_content,
      require => $limits::config_file_require,
    }
  }

  if $limits::config_dir_source {
    file { 'limits.dir':
      ensure  => $limits::config_dir_ensure,
      path    => $limits::config_dir_path,
      source  => $limits::config_dir_source,
      recurse => $limits::config_dir_recurse,
      purge   => $limits::config_dir_purge,
      force   => $limits::config_dir_purge,
      require => $limits::config_file_require,
    }
  }

  # Extra classes
  if $limits::my_class {
    include $limits::my_class
  }
}
