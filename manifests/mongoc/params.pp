# PRIVATE CLASS: do not use directly
class mongodb::mongoc::params inherits mongodb::server {

  # Default to RedHat configuration settings
  $settings = {
    systemLog   => {
      destination => 'file',
      path        => '/var/log/mongodb/mongoc.log',
      logAppend   => true,
    },

    processManagement => {
      pidFilePath => '/var/run/mongodb/mongoc.pid',
      fork        => true,
    },

    net         => {
      bindIp    => '127.0.0.1',
      port      => 27019,
    },

    storage     => {
      dbPath    => '/var/lib/mongodb',
    },

    sharding => {
      clusterRole => 'configsvr',
    },
  }

}
