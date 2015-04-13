# Encoding: UTF-8

require 'kitchen/driver/dummy'
require 'kitchen/provisioner/dummy'
require 'kitchen/transport/ssh'
require 'kitchen/verifier/dummy'
require_relative '../spec_helper'
require_relative '../../lib/kitchen/instance_patch'

describe Kitchen::Instance do
  let(:driver) { nil }
  let(:instance) do
    Kitchen::Instance.new(
      driver: driver,
      transport: Kitchen::Transport::Ssh.new,
      suite: Kitchen::Suite.new(name: 'test'),
      platform: Kitchen::Platform.new(name: 'test'),
      provisioner: Kitchen::Provisioner::Dummy.new,
      verifier: Kitchen::Verifier::Dummy.new,
      state_file: Class.new.new
    )
  end

  describe '#setup_transport' do
    context 'a non-Localhost driver' do
      let(:driver) { Kitchen::Driver::Dummy.new }

      it 'uses the SSH transport' do
        expected = Kitchen::Transport::Ssh
        expect(instance.transport).to be_an_instance_of(expected)
      end
    end

    context 'the Localhost driver' do
      let(:driver) { Kitchen::Driver::Localhost.new }

      it 'uses the Localhost transport' do
        expected = Kitchen::Transport::Localhost
        expect(instance.transport).to be_an_instance_of(expected)
      end
    end
  end
end
