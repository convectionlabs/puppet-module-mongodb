# == Class: mongodb::mongod::users
#
# Class for creating mongodb users.
#
# PRIVATE CLASS: do not call directly
#
class mongodb::mongod::users {

  $users        = $::mongodb::mongod::users
  $hieramerge   = $::mongodb::mongod::hieramerge

  # Load the Hiera based database definitions (if enabled and present)
  #
  # NOTE: hiera hash merging does not work in a parameterized class
  #   definition; so we call it here.
  #
  # http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  # https://tickets.puppetlabs.com/browse/HI-118
  #

  $_users = $hieramerge ? {
    true    => hiera_hash('mongodb::mongod::users', $users),
    # Fall back to user provided class parameter / priority based hiera lookup
    default => $users,
  }

  if $_users {
    create_resources('::mongodb::user', $_users)
  }

}

