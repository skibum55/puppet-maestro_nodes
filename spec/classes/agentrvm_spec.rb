require 'spec_helper'

describe 'maestro_nodes::agentrvm' do

  let(:facts) { centos_facts }

  let(:params) { {
    :agent_user => 'username'
  } }

  it { should contain_rvm__system_user('username') }

end