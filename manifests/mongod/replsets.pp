# == Class: mongodb::server::replsets
#
# Class for creating mongodb replica sets.
#
# PRIVATE CLASS: do not call directly
#
class mongodb::mongod::replsets {

  $replsets   = $::mongodb::mongod::replsets
  $hieramerge = $::mongodb::mongod::hieramerge

  $defaults   = {
    ensure  => 'present',
  }

  # Load the Hiera based replica sets (if enabled and present)
  #
  # NOTE: hiera hash merging does not work in a parameterized class
  #   definition; so we call it here.
  #
  # http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  # https://tickets.puppetlabs.com/browse/HI-118
  #
  $_replsets = $hieramerge ? {
    true    => hiera_hash('mongodb::mongod::replsets', $replsets),
    # Fall back to user provided class parameter / priority based hiera lookup
    default => $replsets,
  }

  if $_replsets {
    create_resources('mongodb_replset', $_replsets, $defaults)
  }

}

