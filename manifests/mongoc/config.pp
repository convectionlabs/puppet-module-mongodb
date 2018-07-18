# PRIVATE CLASS: do not call directly
class mongodb::mongoc::config {

  $ensure               = $::mongodb::mongoc::ensure
  $config               = $::mongodb::mongoc::config
  $user                 = $::mongodb::mongoc::user
  $group                = $::mongodb::mongoc::group
  $init_script          = $::mongodb::mongoc::init_script
  $init_script_content  = $::mongodb::mongoc::init_script_content

  $settings             = $::mongodb::mongoc::final_settings
  $dbpath               = $settings['storage']['dbPath']

  $sorted_yaml          = $::mongodb::server::sorted_yaml


  ensure_resource('file', $dbpath, {
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
  })

  file { $config:
    content => inline_template("# !!! This file managed by puppet !!!\n${sorted_yaml}"),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Class['::mongodb::mongoc::service'],
  }

  file { $init_script:
    owner     => 'root',
    group     => 'root',
    mode      => '0555',
    content   => $init_script_content ? {
      undef   => template('mongodb/mongoc-init.erb-redhat'),
      default => inline_template($init_script_content),
    },
  }

}
