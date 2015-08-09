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
require 'kitchen/platform'
require_relative 'shell_out'

module Kitchen
  module Localhost
    # A customized platform class that figures out on its own whether we're on
    # a Windows or *nix system, rather than relying on platform name.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Platform < Kitchen::Platform
      include Kitchen::Localhost::ShellOut

      #
      # Figure out automatically whether localhost is a Windows or *nix system.
      #
      # (see Platform#initialize)
      #
      def initialize(options = {})
        if windows_os?
          options[:os_type] = 'windows'
          options[:shell_type] = 'powershell'
        end
        super(options)
      end
    end
  end
end
