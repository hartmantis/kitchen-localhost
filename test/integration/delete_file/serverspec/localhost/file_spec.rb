# Encoding: UTF-8

require 'spec_helper'

describe file("#{Dir.tmpdir}/testing_kitchen_localhost") do
  it 'does not exist' do
    expect(subject).not_to be_file
  end
end
