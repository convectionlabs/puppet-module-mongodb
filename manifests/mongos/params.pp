# PRIVATE CLASS: do not use directly
class mongodb::mongos::params inherits mongodb::server {

  $settings = {
    systemLog   => {
      destination => 'file',
      path        => '/var/log/mongodb/mongos.log',
      logAppend   => true,
    },

    processManagement => {
      pidFilePath => '/var/run/mongodb/mongos.pid',
      fork        => true,
    },

    net         => {
      bindIp    => '127.0.0.1',
      port      => '27017',
    },

  }

}
