# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/kitchen/localhost/version'

describe Kitchen::Localhost::VERSION do
  it 'is a valid version string' do
    expected = /^[0-9]+\.[0-9]+\.[0-9]+(\.(dev|(alpha|beta|rc)\.[0-9]+))?$/
    expect(subject).to match(expected)
  end
end
