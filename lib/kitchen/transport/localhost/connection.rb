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

require 'fileutils'
require 'kitchen/shell_out'
require_relative '../localhost'

module Kitchen
  module Transport
    class Localhost < Kitchen::Transport::Base
      # Connection class for the Localhost transport.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Connection < Kitchen::Transport::Base::Connection
        include Kitchen::ShellOut

        #
        # Execute a given command by shelling out and just running it.
        #
        # (see Base::Connection#execute)
        #
        # @raise [Kitchen::Transport::LocalhostFailed] if shell exits non-zero
        #
        def execute(command)
          return if command.nil?
          logger.debug("[Localhost] #{self} (#{command})")
          begin
            run_command(command)
          rescue StandardError => err
            raise(Kitchen::Transport::LocalhostFailed, err.message)
          end
        end

        #
        # Upload a set of local files to a 'remote' (aka Kitchen temp dir)
        #
        # (see Base::Connection#upload)
        #
        def upload(locals, remote)
          FileUtils.mkdir_p(remote)
          Array(locals).each do |local|
            FileUtils.cp_r(local, remote)
            logger.debug("[Localhost] Copied '#{local}' to '#{remote}'")
          end
          logger.debug("[Localhost] File copying to '#{remote}' complete")
        end
      end
    end
  end
end
