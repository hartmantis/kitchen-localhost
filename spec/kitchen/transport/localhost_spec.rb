# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/kitchen/transport/localhost'

describe Kitchen::Transport::Localhost do
  let(:transport) { described_class.new }

  it 'sets the API version' do
    expect(described_class.instance_variable_get(:@api_version)).to eq(1)
  end

  it 'sets the plugin version' do
    expected = /^[0-9]+\.[0-9]+\.[0-9]+(\.(dev|(alpha|beta|rc)\.[0-9]+))?$/
    res = described_class.instance_variable_get(:@plugin_version)
    expect(res).to match(expected)
  end

  describe '#connection' do
    let(:state) { {} }

    it 'returns a connection instance' do
      expected = Kitchen::Transport::Localhost::Connection
      expect(transport.connection(state)).to be_an_instance_of(expected)
    end
  end
end
