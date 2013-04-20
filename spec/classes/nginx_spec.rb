require 'spec_helper'

describe 'maestro_nodes::nginx' do

  default_params = {
      :maestro_port => '8080',
  }

  let(:facts) { {
      :fqdn => "maestro.acme.com",
  }.merge centos_facts }

  let(:params) { default_params }

  context "with default parameters" do
    it { should contain_nginx__resource__vhost("maestro.acme.com").with(
                    :ssl => false,
                    :listen_port => '80',
                    :proxy => 'http://maestro_app',
                ) }

    it { should contain_nginx__resource__upstream("maestro_app").with_members(["localhost:8080"]) }

    it { should_not contain_file('/etc/nginx/conf.d/default.conf') }
  end

  context "with SSL" do
    let(:params) { default_params.merge( {
        :ssl => true,
        :ssl_cert => '/etc/ssl/certs/maestro.acme.com.crt',
        :ssl_key => '/etc/ssl/certs/maestro.acme.com.key',
    }) }
    it { should contain_nginx__resource__vhost("maestro.acme.com").with(
                    :ssl => true,
                    :ssl_cert => '/etc/ssl/certs/maestro.acme.com.crt',
                    :ssl_key => '/etc/ssl/certs/maestro.acme.com.key',
                    :listen_port => '443',
                    :proxy => 'http://maestro_app',
                ) }

    it { should contain_nginx__resource__upstream("maestro_app").with_members(["localhost:8080"]) }

    it { should contain_file('/etc/nginx/conf.d/default.conf').with_source("puppet:///modules/eval/nginx/default.conf") }
  end

end