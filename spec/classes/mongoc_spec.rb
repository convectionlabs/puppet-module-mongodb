require 'spec_helper'

describe 'mongodb::mongoc' do
  let :facts do { :osfamily => 'RedHat', } end
  let(:params) { {:settings => { 'sharding' => { 'clusterRole' => 'configsvr' } } } }

  context 'with defaults' do
    it { should contain_class('mongodb::mongoc::install') }
    it { should contain_class('mongodb::mongoc::config') }
    it { should contain_class('mongodb::mongoc::service') }
  end

end
