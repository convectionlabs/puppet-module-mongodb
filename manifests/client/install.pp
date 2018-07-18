# PRIVATE CLASS: do not call directly
class mongodb::client::install {

  $ensure           = $::mongodb::client::ensure
  $package_name     = $::mongodb::client::package_name
  $package_version  = $::mongodb::client::package_version

  $_ensure = $package_version ? {
    undef   => $ensure,
    default => $package_version,
  }

  ensure_resource('package', $package_name, {
    ensure  => $_ensure,
  })

}
