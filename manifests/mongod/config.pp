# PRIVATE CLASS: do not call directly
class mongodb::mongod::config {

  $ensure               = $::mongodb::mongod::ensure
  $config               = $::mongodb::mongod::config
  $user                 = $::mongodb::mongod::user
  $group                = $::mongodb::mongod::group

  $init_script          = $::mongodb::mongod::init_script
  $init_script_content  = $::mongodb::mongod::init_script_content

  $settings             = $::mongodb::mongod::final_settings
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
    notify  => Class['::mongodb::mongod::service'],
  }

  $tmpl = hiera('mongodb::version') ? {
    /^2\.\d+\.\d+/  => 'mongod-2.x-init.erb',
    default         => 'mongod-3.x-init.erb',
  }

  file { $init_script:
    owner     => 'root',
    group     => 'root',
    mode      => '0555',
    content   => $init_script_content ? {
      undef   => template("mongodb/$tmpl"),
      default => inline_template($init_script_content),
    },
  }

}
