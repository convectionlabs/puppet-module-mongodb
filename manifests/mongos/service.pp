# PRIVATE CLASS: do not call directly
class mongodb::mongos::service {

  $ensure           = $::mongodb::mongos::ensure

  $service_name     = $::mongodb::mongos::service_name
  $service_provider = $::mongodb::mongos::service_provider
  $service_status   = $::mongodb::mongos::service_status

  $settings         = $::mongodb::mongos::final_settings
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
