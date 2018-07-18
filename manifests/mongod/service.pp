# PRIVATE CLASS: do not call directly
class mongodb::mongod::service {

  $ensure           = $::mongodb::mongod::ensure

  $service_name     = $::mongodb::mongod::service_name
  $service_provider = $::mongodb::mongod::service_provider
  $service_status   = $::mongodb::mongod::service_status

  $settings         = $::mongodb::mongod::final_settings
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
