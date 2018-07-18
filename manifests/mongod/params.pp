# PRIVATE CLASS: do not use directly
class mongodb::mongod::params inherits mongodb::server {

  # Default to RedHat configuration settings
  $settings = {
    systemLog   => {
      destination => 'file',
      path        => '/var/log/mongodb/mongodb.log',
      logAppend   => true,
    },

    processManagement => {
      pidFilePath => '/var/run/mongodb/mongodb.pid',
      fork        => true,
    },

    net         => {
      bindIp    => '127.0.0.1',
      port      => '27017',
    },

    storage     => {
      dbPath    => '/var/lib/mongodb',
    }
  }

}
