require 'spec_helper'

describe 'mongodb::client::install', :type => :class do

  shared_context 'defaults' do
    let(:pre_condition) { 'include mongodb::client' }

    it {
      should contain_package('mongodb').with({
        :ensure => true,
      })
    }

  end

  shared_context 'with_custom_package' do
    let(:pre_condition) { [
      "class mongodb::client { $ensure = true $package_name = 'custom_package_name' }",
      "include mongodb::client"
    ]}

    it {
      should contain_package('custom_package_name').with({
        :ensure => true,
      })
    }
  end

  shared_context 'with_custom_package_and_version' do
    let(:pre_condition) { [
      "class mongodb::client { $ensure = true $package_name = 'custom_package_name' $package_version = '1.2.3.4' }",
      "include mongodb::client",
    ]}

    it {
      should contain_package('custom_package_name').with({
        :ensure => '1.2.3.4',
      })
    }
  end

  context 'when deploying on RedHat' do
    let (:facts) { { :osfamily => 'RedHat' } }

    context 'using defaults' do
      include_context 'defaults'
    end

    context 'using custom package' do
      include_context 'with_custom_package'
    end

    context 'using version' do
      context 'with custom package' do
        include_context 'with_custom_package_and_version'
      end
    end


  end

end
