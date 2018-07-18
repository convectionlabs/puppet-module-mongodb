require 'spec_helper'

describe 'mongodb::client', :type => :class do

  let (:facts) { { :osfamily => 'RedHat' } }

  it {
    should contain_class('mongodb::client::install')
  }

end
