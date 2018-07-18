# This installs a MongoDB server. See README.md for more details.
class mongodb::mongod (

  $ensure               = true,

  $user                 = $::mongodb::server::user,
  $group                = $::mongodb::server::group,
  $config               = $::mongodb::server::config,

  $package_name         = $::mongodb::server::package_name,
  $package_version      = $::mongodb::server::package_version,
  $auth_schema_override = $::mongodb::server::auth_schema_override,

  $service_name         = $::mongodb::server::service_name,
  $service_provider     = $::mongodb::server::service_provider,
  $service_status       = $::mongodb::server::service_status,

  $settings             = {},

  $dbs                  = undef,
  $users                = undef,
  $replsets             = undef,

  $hieramerge           = $::mongodb::server::hieramerge,

  $init_script          = '/etc/init.d/mongod',
  $init_script_content  = undef,

) inherits mongodb::mongod::params {

  $default_settings = $::mongodb::mongod::params::settings

  if $hieramerge {
    $hiera_settings = hiera_hash('mongodb::mongod::settings', $settings)
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
  validate_integer        ( $auth_schema_override)
  validate_string         ( $service_name   )
  validate_bool           ( $hieramerge     )
  validate_hash           ( $final_settings )
  validate_absolute_path  ( $init_script    )

  # Validate minimum configuration settings
  validate_hash           ( $final_settings['net']                              )
  validate_hash           ( $final_settings['storage']                          )
  validate_hash           ( $final_settings['processManagement']                )

  validate_string         ( $final_settings['net']['bindIp']                    )
  validate_absolute_path  ( $final_settings['storage']['dbPath']                )
  validate_absolute_path  ( $final_settings['processManagement']['pidFilePath'] )

  # Dependencies definition
  include 'mongodb::repo'
  include 'mongodb::mongod::install'
  include 'mongodb::mongod::config'
  include 'mongodb::mongod::service'
  include 'mongodb::mongod::running_config'
  include 'mongodb::mongod::dbs'
  include 'mongodb::mongod::users'
  include 'mongodb::mongod::replsets'

  Class['mongodb::repo']                   -> Class['mongodb::mongod::install']
  Class['mongodb::mongod::install']        -> Class['mongodb::mongod::config']
  Class['mongodb::mongod::config']         -> Class['mongodb::mongod::service']
  Class['mongodb::mongod::service']        -> Class['mongodb::mongod::running_config']
  Class['mongodb::mongod::running_config'] -> Class['mongodb::mongod::dbs']
  Class['mongodb::mongod::dbs']            -> Class['mongodb::mongod::users']
  Class['mongodb::mongod::users']          -> Class['mongodb::mongod::replsets']

}
