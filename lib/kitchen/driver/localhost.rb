# Encoding: UTF-8
#
# Author:: Jonathan Hartman (<j@p4nt5.com>)
#
# Copyright (C) 2015, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'kitchen'
require 'fileutils'
require 'socket'
require_relative '../localhost/version'
require_relative '../instance'

module Kitchen
  module Driver
    # Localhost driver for Kitchen.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Localhost < Kitchen::Driver::Base
      kitchen_driver_api_version 2

      plugin_version Kitchen::Localhost::VERSION

      #
      # Create the temp dirs on the local filesystem for Kitchen.
      #
      # (see Base#create)
      def create(state)
        state[:hostname] = Socket.gethostname
        logger.info("[Localhost] Instance #{instance} ready.")
      end

      #
      # Clean up the temp dirs left behind
      #
      # (see Base#destroy)
      #
      def destroy(_)
        path = instance.provisioner[:root_path]
        FileUtils.rm_rf(path)
        logger.info("[Localhost] Deleted tmp dir '#{path}'.")
      end
    end
  end
end
