# PRIVATE CLASS: do not call directly
class mongodb::mongoc::service {

  $ensure           = $::mongodb::mongoc::ensure

  $service_name     = $::mongodb::mongoc::service_name
  $service_provider = $::mongodb::mongoc::service_provider
  $service_status   = $::mongodb::mongoc::service_status

  $settings         = $::mongodb::mongoc::final_settings
  $bindip           = $settings['net']['bindIp']
  $port             = $settings['net']['port']

  service { $service_name:
    ensure    => $ensure,
    enable    => $ensure,
    provider  => $service_provider,
    status    => $service_status,
  }

  if $ensure {
    mongodb_conn_validator { $service_name:
      server  => $bindip,
      port    => $port,
      timeout => '240',
      require => Service[$service_name],
    }
  }

}
