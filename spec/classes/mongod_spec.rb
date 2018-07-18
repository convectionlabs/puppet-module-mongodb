require 'spec_helper'

describe 'mongodb::mongod' do
  let :facts do { :osfamily => 'RedHat', } end

  context 'with defaults' do
    it { should contain_class('mongodb::mongod::install') }
    it { should contain_class('mongodb::mongod::config') }
    it { should contain_class('mongodb::mongod::service') }
    it { should contain_class('mongodb::mongod::dbs') }
    it { should contain_class('mongodb::mongod::users') }
    it { should contain_class('mongodb::mongod::replsets') }
  end

end
