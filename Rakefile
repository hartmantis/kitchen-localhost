# Encoding: UTF-8

require 'bundler/setup'
require 'rubocop/rake_task'
require 'cane/rake_task'
require 'rspec/core/rake_task'
require 'kitchen/rake_tasks'

Cane::RakeTask.new

RuboCop::RakeTask.new

desc 'Display LOC stats'
task :loc do
  puts "\n## LOC Stats"
  sh 'countloc -r lib'
end

RSpec::Core::RakeTask.new(:spec)

Kitchen::RakeTasks.new

task default: [:cane, :rubocop, :loc, :spec]
