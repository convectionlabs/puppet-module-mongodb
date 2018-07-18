# This installs a MongoDB configuration server. See README.md for more details.
class mongodb::mongoc (

  $ensure               = true,

  $user                 = $::mongodb::server::user,
  $group                = $::mongodb::server::group,

  $config               = '/etc/mongoc.conf',

  $package_name         = $::mongodb::server::package_name,
  $package_version      = $::mongodb::server::package_version,

  $service_name         = 'mongoc',
  $service_provider     = $::mongodb::server::service_provider,
  $service_status       = undef,

  $settings             = {},
  $hieramerge           = $::mongodb::server::hieramerge,

  $init_script          = '/etc/init.d/mongoc',
  $init_script_content  = undef,

) inherits mongodb::mongoc::params {

  $default_settings = $::mongodb::mongoc::params::settings

  if $hieramerge {
    $hiera_settings = hiera_hash('mongodb::mongoc::settings', $settings)
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
  validate_hash           ( $final_settings['storage']                          )
  validate_hash           ( $final_settings['processManagement']                )
  validate_hash           ( $final_settings['sharding']                         )

  validate_string         ( $final_settings['net']['bindIp']                    )
  validate_absolute_path  ( $final_settings['storage']['dbPath']                )
  validate_absolute_path  ( $final_settings['processManagement']['pidFilePath'] )
  validate_string         ( $final_settings['sharding']['clusterRole']          )

  contain 'mongodb::repo'
  contain 'mongodb::mongoc::install'
  contain 'mongodb::mongoc::config'
  contain 'mongodb::mongoc::service'

}
