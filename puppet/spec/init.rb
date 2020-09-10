require 'spec_helper'

describe 'profile_example' do
  context 'description' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        context "with client" do
          facts = facts.merge({
            :client_enabled => 'yes',
            :client_customers => 'one,two'
          })
          let(:facts) do
            facts
          end
          it do
            is_expected.to contain_file("/etc/client/config")
            is_expected.to contain_file('/etc/cron.d/client').with({'ensure' => 'absent'})
            is_expected.to contain_cron('client')
          end
        end
      end
    end
  end
end
