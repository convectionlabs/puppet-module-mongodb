# PRIVATE CLASS: do not call directly
class mongodb::mongos::config {

  $ensure               = $::mongodb::mongos::ensure
  $config               = $::mongodb::mongos::config
  $user                 = $::mongodb::mongos::user
  $group                = $::mongodb::mongos::group
  $init_script          = $::mongodb::mongos::init_script
  $init_script_content  = $::mongodb::mongos::init_script_content

  $settings             = $::mongodb::mongos::final_settings

  $sorted_yaml          = $::mongodb::server::sorted_yaml

  file { $config:
    content => inline_template("# !!! This file managed by puppet !!!\n${sorted_yaml}"),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Class['::mongodb::mongos::service'],
  }

  file { $init_script:
    owner     => 'root',
    group     => 'root',
    mode      => '0555',
    content   => $init_script_content ? {
      undef   => template('mongodb/mongos-init.erb-redhat'),
      default => inline_template($init_script_content),
    },
  }

}
