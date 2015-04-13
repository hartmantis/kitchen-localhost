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
require_relative 'driver/localhost'
require_relative 'transport/localhost'

module Kitchen
  # Monkey patch the Kitchen::Instance class with the default configs for the
  # Localhost driver/transport.
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Instance
    alias_method :old_setup_transport, :setup_transport

    # If using the Localhost driver, force usage of the Localhost transport.
    #
    # (see Instance#setup_transport)
    #
    def setup_transport
      if @driver.is_a?(Kitchen::Driver::Localhost)
        @transport = Kitchen::Transport::Localhost.new
      end
      old_setup_transport
    end
  end
end
