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
require 'tempfile'
require 'kitchen'
require 'kitchen/shell_out'

module Kitchen
  module Localhost
    # Take Kitchen's ShellOut module and add support for Windows Powershell.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module ShellOut
      include Kitchen::ShellOut

      alias_method :run_command_sh, :run_command

      #
      # Run a given command through the regular shell on any *nix systems or
      # PowerShell on Windows.
      #
      # @param cmd [String] a command to run
      #
      def run_command(cmd)
        windows_os? ? run_command_psh(cmd) : run_command_sh(cmd)
      end

      #
      # Run a given command through PowerShell, accounting for quotes and
      # other difficult-to-account for characters by writing the command out
      # to a temp file, executing it, and cleaning up after.
      #
      # @param cmd [String] a PowerShell command or script to run
      #
      # @raise [ShellCommandFailed] if the command exits non-zero
      #
      def run_command_psh(cmd)
        script = Tempfile.new(%w(kitchen-localhost .ps1))
        script.write(cmd)
        script.close
        begin
          res = run_command_sh("powershell #{script.path}")
        ensure
          script.unlink
        end
        res
      end

      #
      # Do a recursive copy of one path to another, while running the paths
      # through PowerShell on Windows platforms to translate any PSH variables.
      #
      # @param source [String] a source path
      # @param dest [String] a destination path
      #
      def cp_r(source, dest)
        if windows_os?
          source = run_command_psh("\"#{source}\"").strip
          dest = run_command_psh("\"#{dest}\"").strip
        end
        FileUtils.cp_r(source, dest)
      end

      #
      # Do a recursive delete of a given path, while running the path through
      # PowerShell on Windows platforms to translate any PSH variables.
      #
      # @param path [String] a directory to create
      #
      def rm_rf(path)
        path = run_command_psh("\"#{path}\"").strip if windows_os?
        FileUtils.rm_rf(path)
      end

      #
      # Do a recursive mkdir of a given path, while running the path through
      # PowerShell on Windows platforms to translate any PSH variables.
      #
      # @param path [String] a directory to create
      #
      def mkdir_p(path)
        path = run_command_psh("\"#{path}\"").strip if windows_os?
        FileUtils.mkdir_p(path)
      end

      #
      # Check whether the localhost instance is Windows
      #
      # @return [TrueClass, FalseClass] whether localhost is Windows
      #
      def windows_os?
        !RUBY_PLATFORM.match(/mswin|mingw32|windows/).nil?
      end
    end
  end
end
