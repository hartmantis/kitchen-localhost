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

require 'socket'
require 'kitchen'
require 'kitchen/driver/base'
require_relative '../instance_patch'
require_relative '../localhost/shell_out'
require_relative '../localhost/version'

module Kitchen
  module Driver
    # Localhost driver for Kitchen.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Localhost < Kitchen::Driver::Base
      include Kitchen::Localhost::ShellOut

      kitchen_driver_api_version 2
      plugin_version Kitchen::Localhost::VERSION

      default_config :clean_up_on_destroy, true

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
        if config[:clean_up_on_destroy]
          [
            instance.provisioner[:root_path], instance.verifier[:root_path]
          ].each do |p|
            rm_rf(p)
            logger.info("[Localhost] Deleted temp dir '#{p}'.")
          end
        else
          logger.info('[Localhost] Leaving Kitchen temp dirs in place.')
        end
      end
    end
  end
end
