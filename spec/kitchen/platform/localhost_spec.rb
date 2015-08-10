# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/kitchen/platform/localhost'

describe Kitchen::Platform::Localhost do
  let(:options) { {} }
  let(:platform) { described_class.new(options) }

  describe '#initialize' do
    let(:options) { { name: 'default', os_type: 'thing', shell_type: 'tsh' } }
    let(:windows_os?) { nil }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:windows_os?)
        .and_return(windows_os?)
    end

    context 'a non-Windows platform' do
      let(:windows_os?) { false }

      it 'does not override the os_type or shell_type' do
        expect(platform.os_type).to eq('thing')
        expect(platform.shell_type).to eq('tsh')
      end
    end

    context 'a Windows platform' do
      let(:windows_os?) { true }

      it 'overrides the os_type and shell_type' do
        expect(platform.os_type).to eq('windows')
        expect(platform.shell_type).to eq('powershell')
      end
    end
  end
end
