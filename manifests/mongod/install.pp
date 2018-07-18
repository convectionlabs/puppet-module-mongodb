# PRIVATE CLASS: do not call directly
class mongodb::mongod::install {

  $ensure           = $::mongodb::mongod::ensure

  $package_name     = $::mongodb::mongod::package_name
  $package_version  = $::mongodb::mongod::package_version

  $_ensure = $package_version ? {
    undef   => $ensure,
    default => $package_version,
  }

  ensure_resource('package', $package_name, {
    ensure  => $_ensure,
  })

}
