require 'spec_helper'

describe 'dotenv' do
  let(:title) { '/opt/app/.env' }
  let(:params) do
    {
      entries: {
        APP_NAME: 'M-Pab',
        APP_DESC: 'Mental Pabulum',
      },
    }
  end

  it { is_expected.to compile }
  it do
    is_expected.to contain_file('/opt/app/.env').with_content(<<-'EOS')
# Managed by Puppet

APP_NAME="M-Pab"
APP_DESC="Mental Pabulum"
EOS
  end

  context 'when quoting_style is single' do
    let(:params) do
      {
        entries: {
          ANTIVIRUS_CLAMAV_PATH: '["/usr/bin/clamdscan"]',
        },
        quoting_style: 'single',
      }
    end

    it { is_expected.to compile }
    it do
      is_expected.to contain_file('/opt/app/.env').with_content(<<-'EOS')
# Managed by Puppet

ANTIVIRUS_CLAMAV_PATH='["/usr/bin/clamdscan"]'
EOS
    end
  end
end

# vim: ts=2 sw=2 et
