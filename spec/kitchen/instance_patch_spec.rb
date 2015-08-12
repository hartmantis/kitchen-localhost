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

  describe '.lock' do
    it 'returns a Mutex' do
      expect(described_class.lock).to be_an_instance_of(Mutex)
    end
  end

  describe '#test' do
    context 'a non-Localhost driver' do
      let(:driver) { Kitchen::Driver::Dummy.new }

      it 'does nothing with the class Mutex' do
        i = instance
        expect(described_class).not_to receive(:lock)
        expect(i).to receive(:old_test).with(:passing)
        i.test
      end
    end

    context 'the Localhost driver' do
      let(:driver) { Kitchen::Driver::Localhost.new }
      let(:lock) { double }

      it 'locks the class Mutex' do
        i = instance
        expect(described_class).to receive(:lock).and_return(lock)
        expect(lock).to receive(:synchronize).and_yield
        expect(i).to receive(:old_test).with(:passing)
        i.test
      end
    end
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

  describe '#platform' do
    context 'a non-Localhost driver' do
      let(:driver) { Kitchen::Driver::Dummy.new }

      it 'uses the Localhost Platform class' do
        expected = Kitchen::Platform
        expect(instance.platform).to be_an_instance_of(expected)
      end
    end

    context 'the Localhost driver' do
      let(:driver) { Kitchen::Driver::Localhost.new }

      it 'keeps the regular Platform class' do
        expected = Kitchen::Platform::Localhost
        expect(instance.platform).to be_an_instance_of(expected)
      end
    end
  end
end
