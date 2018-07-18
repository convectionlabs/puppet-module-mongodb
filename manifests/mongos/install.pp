# PRIVATE CLASS: do not call directly
class mongodb::mongos::install {

  $ensure           = $::mongodb::mongos::ensure

  $package_name     = $::mongodb::mongos::package_name
  $package_version  = $::mongodb::mongos::package_version

  $_ensure = $package_version ? {
    undef   => $ensure,
    default => $package_version,
  }

  ensure_resource('package', $package_name, {
    ensure  => $_ensure,
  })

}
