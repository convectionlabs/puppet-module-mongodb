# This installs a MongoDB routing service. See README.md for more details.
class mongodb::mongos (

  $ensure               = true,

  $user                 = $::mongodb::server::user,
  $group                = $::mongodb::server::group,

  $config               = '/etc/mongos.conf',

  $package_name         = $::mongodb::server::package_name,
  $package_version      = $::mongodb::server::package_version,

  $service_name         = 'mongos',
  $service_provider     = $::mongodb::server::service_provider,
  $service_status       = undef,

  $settings             = {},
  $hieramerge           = $::mongodb::server::hieramerge,

  $init_script          = '/etc/init.d/mongos',
  $init_script_content  = undef,

) inherits mongodb::mongos::params {

  $default_settings = $::mongodb::mongos::params::settings

  if $hieramerge {
    $hiera_settings = hiera_hash('mongodb::mongos::settings', $settings)
    $final_settings = merge($default_settings, $hiera_settings)
  } else {
    $final_settings = merge($default_settings, $settings)
  }

  # Validate params
  validate_bool           ( $ensure         )
  validate_string         ( $user           )
  validate_string         ( $group          )
  validate_absolute_path  ( $config         )
  validate_string         ( $package_name   )
  validate_string         ( $service_name   )
  validate_bool           ( $hieramerge     )
  validate_hash           ( $final_settings )
  validate_absolute_path  ( $init_script    )

  # Validate minimum configuration settings
  validate_hash           ( $final_settings['net']                              )
  validate_hash           ( $final_settings['processManagement']                )
  validate_hash           ( $final_settings['sharding']                         )

  validate_string         ( $final_settings['net']['bindIp']                    )
  validate_absolute_path  ( $final_settings['processManagement']['pidFilePath'] )
  validate_string         ( $final_settings['sharding']['configDB']             )

  contain 'mongodb::repo'
  contain 'mongodb::mongos::install'
  contain 'mongodb::mongos::config'
  contain 'mongodb::mongos::service'

}
