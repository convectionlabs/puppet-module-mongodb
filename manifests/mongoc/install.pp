# PRIVATE CLASS: do not call directly
class mongodb::mongoc::install {

  $ensure           = $::mongodb::mongoc::ensure

  $package_name     = $::mongodb::mongoc::package_name
  $package_version  = $::mongodb::mongoc::package_version

  $_ensure = $package_version ? {
    undef   => $ensure,
    default => $package_version,
  }

  ensure_resource('package', $package_name, {
    ensure  => $_ensure,
  })

}
