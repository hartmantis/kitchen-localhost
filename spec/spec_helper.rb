# Encoding: UTF-8

require 'rspec'
require 'simplecov'
require 'simplecov-console'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)
SimpleCov.minimum_coverage(100)
SimpleCov.start do
  add_filter '/vendor/'
end
