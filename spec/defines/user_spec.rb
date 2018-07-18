require 'spec_helper'

describe 'mongodb::user', :type => :define do
  let(:title) { 'testuser' }

  let(:params) {
    { 'database'      => 'testdb',
      'ensure'        => 'present',
      'password'      => 'testpass',
      'roles'         => [ 'dbAdmin' ],
    }
  }

  it 'should contain mongodb_user with mongodb_database requirement' do
    should contain_mongodb_user('testuser')\
      .with_require('Mongodb_database[testdb]')
  end

  it 'should contain mongodb_user with proper database name' do
    should contain_mongodb_user('testuser')\
      .with_database('testdb')
  end

  it 'should contain mongodb_user with proper roles' do
    should contain_mongodb_user('testuser')\
      .with_roles(["dbAdmin"])
  end

  it 'should prefer password_hash instead of password' do
    params.merge!({'password_hash' => 'securehash'})
    should contain_mongodb_user('testuser')\
      .with_password_hash('securehash')
  end

end
