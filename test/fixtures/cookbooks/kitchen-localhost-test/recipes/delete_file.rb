# Encoding: UTF-8
#
# Cookbook Name:: kitchen-localhost-test
# Recipe:: delete_file
#

file '/tmp/testing_kitchen_localhost' do
  action :delete
end
