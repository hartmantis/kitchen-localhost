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
require 'kitchen/transport/base'
require_relative '../localhost/version'
require_relative 'localhost/connection'

module Kitchen
  module Transport
    # Localhost transport for Kitchen.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Localhost < Kitchen::Transport::Base
      kitchen_transport_api_version 1

      plugin_version Kitchen::Localhost::VERSION

      # (see Base#connection)
      #
      def connection(state, &block)
        Kitchen::Transport::Localhost::Connection.new(state, &block)
      end
    end

    # An exception class for transport errors from the Localhost plugin.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class LocalhostFailed < TransportFailed; end
  end
end
