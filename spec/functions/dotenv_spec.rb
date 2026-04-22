require 'spec_helper'

describe 'dotenv' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, 'dotenv(): requires a hash argument') }
  it { is_expected.to run.with_params({}, 'double', 0).and_raise_error(Puppet::ParseError, 'dotenv(): too many arguments') }
  it { is_expected.to run.with_params(0).and_raise_error(Puppet::ParseError, 'dotenv(): requires a hash argument') }

  context 'default' do
    input = {
      'APP_NAME' => 'M-Pab',
      'APP_DESC' => 'Mental Pabulum',
    }

    output = <<-EOS
# Managed by Puppet

APP_NAME="M-Pab"
APP_DESC="Mental Pabulum"
EOS

    it { is_expected.to run.with_params(input).and_return(output) }
  end

  context 'values needing quoting rules' do
    it 'keeps apostrophes in double-quoted values' do
      input = {
        'AUTHOR' => "O'Reilly",
      }

      output = <<-'EOS'
# Managed by Puppet

AUTHOR="O'Reilly"
EOS

      is_expected.to run.with_params(input).and_return(output)
    end

    it 'escapes json-like values in double mode' do
      input = {
        'ANTIVIRUS_CLAMAV_PATH' => '["/usr/bin/clamdscan"]',
      }

      output = <<-'EOS'
# Managed by Puppet

ANTIVIRUS_CLAMAV_PATH="[\"/usr/bin/clamdscan\"]"
EOS

      is_expected.to run.with_params(input).and_return(output)
    end

    it 'uses single quotes when requested' do
      input = {
        'ANTIVIRUS_CLAMAV_PATH' => '["/usr/bin/clamdscan"]',
      }

      output = <<-'EOS'
# Managed by Puppet

ANTIVIRUS_CLAMAV_PATH='["/usr/bin/clamdscan"]'
EOS

      is_expected.to run.with_params(input, 'single').and_return(output)
    end

    it 'falls back to double quotes when a single-quoted value contains single quotes' do
      input = {
        'PATH' => %q{C:\Program Files\Acme "Suite" O'Reilly},
      }

      output = <<-'EOS'
# Managed by Puppet

PATH="C:\Program Files\Acme \"Suite\" O'Reilly"
EOS

      is_expected.to run.with_params(input, 'single').and_return(output)
    end

    it 'rejects unsupported quoting styles' do
      input = {
        'APP_NAME' => 'M-Pab',
      }

      is_expected.to run.with_params(input, 'triple').and_raise_error(Puppet::ParseError, 'dotenv(): quoting_style must be "single" or "double"')
    end
  end
end

# vim: ts=2 sw=2 et
