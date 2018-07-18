# == Class: mongodb::mongod::dbs
#
# Class for creating mongodb databases and users.
#
# PRIVATE CLASS: do not call directly
#
class mongodb::mongod::dbs {

  $dbs        = $::mongodb::mongod::dbs
  $hieramerge = $::mongodb::mongod::hieramerge

  $defaults   = {
    ensure  => 'present',
    tries   => 10,
  }


  # Load the Hiera based database definitions (if enabled and present)
  #
  # NOTE: hiera hash merging does not work in a parameterized class
  #   definition; so we call it here.
  #
  # http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  # https://tickets.puppetlabs.com/browse/HI-118
  #

  if $::mongodb_isprimary == "true" {
    $_dbs = $hieramerge ? {
      true    => hiera_hash('mongodb::mongod::dbs', $dbs),
      # Fall back to user provided class parameter / priority based hiera lookup
      default => $dbs,
    }

    if $_dbs {
      create_resources('mongodb_database', $_dbs, $defaults)
    }
  }
}

