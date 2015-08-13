# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/kitchen/driver/localhost'

describe Kitchen::Driver::Localhost do
  let(:logger) { double(info: true) }
  let(:config) { {} }
  let(:driver) { described_class.new(config) }

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

  describe '.initialize' do
    context 'an empty config input' do
      let(:config) { {} }

      it 'defaults clean_up_on_destroy to true' do
        expect(driver[:clean_up_on_destroy]).to eq(true)
      end
    end

    context 'a config input with clean_up_on_destroy set to false' do
      let(:config) { { clean_up_on_destroy: false } }

      it 'sets clean_up_on_destroy to false' do
        expect(driver[:clean_up_on_destroy]).to eq(false)
      end
    end
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
      allow_any_instance_of(described_class).to receive(:rm_rf)
    end

    context 'default config' do
      let(:config) { {} }

      it 'deletes the provisioner and verifier temp dirs' do
        d = driver
        expect(d).to receive(:rm_rf).with(provisioner_path)
        expect(d).to receive(:rm_rf).with(verifier_path)
        d.destroy(state)
      end
    end

    context 'a config with clean_up_on_destroy set to false' do
      let(:config) { { clean_up_on_destroy: false } }

      it 'does not delete any directories' do
        d = driver
        expect(d).not_to receive(:rm_rf)
        d.destroy(state)
      end
    end
  end
end
