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

  describe '#create' do
    let(:state) { {} }
    let(:hostname) { 'example.com' }

    before(:each) do
      allow(Socket).to receive(:gethostname).and_return(hostname)
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
