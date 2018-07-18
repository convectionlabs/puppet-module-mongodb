# By default, this will remove the yum mongo repo
# set 'mongodb::repo::manage' to true in hiera to change this behavior
#
class mongodb::repo (
  $manage       = hiera('$::mongodb:repo:manage', false),
){
  validate_bool   ($manage)

  case hiera('mongodb::version') {
    /^(\d+\.\d+).*/: {
      $baseurl  = "http://repo.mongodb.com/yum/redhat/6/mongodb-enterprise/$1/\$basearch/"
    }
    default: {
      # Default to 3.0.x since it's current
      $baseurl  = "http://repo.mongodb.com/yum/redhat/6/mongodb-enterprise/3.0/\$basearch/"
    }
  }
  if $manage == true {
    yumrepo { 'repo_mongodb_com':
      baseurl   => $baseurl,
      descr     => 'MongoDB Enterprise repo',
      enabled   => '1',
      gpgcheck  => '0',
      priority  => '1',
    }
  } else {
    yumrepo { 'repo_mongodb_com':
      ensure    => absent,
      enabled   => false,
    }
  }
}
