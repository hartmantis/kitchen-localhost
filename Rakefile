# Encoding: UTF-8

require 'bundler/setup'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'kitchen/rake_tasks'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

Kitchen::RakeTasks.new

task default: [:rubocop, :spec]
