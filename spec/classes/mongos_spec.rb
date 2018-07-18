require 'spec_helper'

describe 'mongodb::mongos' do
  let :facts do { :osfamily => 'RedHat', } end
  let(:params) { {:settings => { 'sharding' => { 'configDB' => '127.0.0.1' } } } }

  context 'with defaults' do
    it { should contain_class('mongodb::mongos::install') }
    it { should contain_class('mongodb::mongos::config') }
    it { should contain_class('mongodb::mongos::service') }
  end

end
