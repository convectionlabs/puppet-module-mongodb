# Class for installing a MongoDB client shell (CLI).
#
# == Parameters
#
# [ensure] Desired ensure state of the package. Optional.
#   Defaults to 'true'
#
# [package_name] Name of the package to install the client from. Default
#   is OS dependent.
#
class mongodb::client (

  $ensure           = true,
  $package_name     = 'mongodb',
  $package_version  = undef,

) {

  validate_bool   ( $ensure       )
  validate_string ( $package_name )

  contain 'mongodb::repo'
  contain 'mongodb::client::install'

}
