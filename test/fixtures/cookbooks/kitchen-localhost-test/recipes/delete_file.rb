# Encoding: UTF-8
#
# Cookbook Name:: kitchen-localhost-test
# Recipe:: delete_file
#

require 'tmpdir'

file File.join(Dir.tmpdir, 'testing_kitchen_localhost') do
  action :delete
end
