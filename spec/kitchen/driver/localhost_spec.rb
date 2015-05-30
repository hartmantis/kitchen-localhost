# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/kitchen/driver/localhost'

describe Kitchen::Driver::Localhost do
  let(:logger) { double(info: true) }
  let(:driver) { described_class.new }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:logger)
      .and_return(logger)
  end

  it 'sets the API version' do
    expect(described_class.instance_variable_get(:@api_version)).to eq(2)
  end

  it 'sets the plugin version' do
    expected = /^[0-9]+\.[0-9]+\.[0-9]+(\.(dev|(alpha|beta|rc)\.[0-9]+))?$/
    res = described_class.instance_variable_get(:@plugin_version)
    expect(res).to match(expected)
  end

  describe '.lock' do
    it 'returns a Mutex' do
      expect(described_class.lock).to be_an_instance_of(Mutex)
    end
  end

  describe '.lock!' do
    let(:locked?) { nil }
    let(:lock) { double(locked?: locked?, lock: true) }

    before(:each) do
      allow(described_class).to receive(:lock).and_return(lock)
    end

    context 'already locked' do
      let(:locked?) { true }

      it 'does nothing' do
        expect(lock).not_to receive(:lock)
        described_class.lock!
      end
    end

    context 'not locked' do
      let(:locked!) { false }

      it 'locks' do
        expect(lock).to receive(:lock)
        described_class.lock!
      end
    end
  end

  describe '.unlock!' do
    let(:locked?) { nil }
    let(:lock) { double(locked?: locked?, unlock: true) }

    before(:each) do
      allow(described_class).to receive(:lock).and_return(lock)
    end

    context 'already locked' do
      let(:locked?) { true }

      it 'unlocks' do
        expect(lock).to receive(:unlock)
        described_class.unlock!
      end
    end

    context 'not locked' do
      let(:locked!) { false }

      it 'does nothing' do
        expect(lock).not_to receive(:unlock)
        described_class.unlock!
      end
    end
  end

  describe '#create' do
    let(:state) { {} }
    let(:hostname) { 'example.com' }

    before(:each) do
      allow(Socket).to receive(:gethostname).and_return(hostname)
    end

    it 'locks the class-level Mutex' do
      expect(described_class).to receive(:lock!)
      driver.create(state)
    end

    it 'adds the system hostname to the state' do
      s = state
      driver.create(s)
      expect(s[:hostname]).to eq(hostname)
    end
  end

  describe '#destroy' do
    let(:state) { {} }
    let(:provisioner_path) { '/tmp/1' }
    let(:verifier_path) { '/tmp/2' }
    let(:instance) do
      double(provisioner: { root_path: provisioner_path },
             verifier: { root_path: verifier_path })
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:instance)
        .and_return(instance)
      allow(FileUtils).to receive(:rm_rf).and_return(true)
    end

    it 'locks and unlocks the class-level Mutex' do
      expect(described_class).to receive(:lock!)
      expect(described_class).to receive(:unlock!)
      driver.destroy(state)
    end

    it 'deletes the provisioner temp dir' do
      expect(FileUtils).to receive(:rm_rf).with(provisioner_path)
      driver.destroy(state)
    end

    it 'deletes the verifier temp dir' do
      expect(FileUtils).to receive(:rm_rf).with(verifier_path)
      driver.destroy(state)
    end
  end
end
