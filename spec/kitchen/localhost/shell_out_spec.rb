# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/kitchen/localhost/shell_out'

describe Kitchen::Localhost::ShellOut do
  let(:test_class) { Class.new { include Kitchen::Localhost::ShellOut } }
  let(:test_obj) { test_class.new }

  describe '#run_command' do
    let(:windows_os?) { nil }

    before(:each) do
      allow_any_instance_of(test_class).to receive(:windows_os?)
        .and_return(windows_os?)
      allow_any_instance_of(test_class).to receive(:run_command_psh)
      allow_any_instance_of(test_class).to receive(:run_command_sh)
    end

    context 'a non-Windows platform' do
      let(:windows_os?) { false }

      it 'calls the regular shell' do
        o = test_obj
        expect(o).to receive(:run_command_sh).with('a command')
        o.run_command('a command')
      end
    end

    context 'a Windows platform' do
      let(:windows_os?) { true }

      it 'calls PowerShell' do
        o = test_obj
        expect(o).to receive(:run_command_psh).with('a command')
        o.run_command('a command')
      end
    end
  end

  describe '#run_command_psh' do
    let(:tempfile) do
      double(write: true, close: true, unlink: true, path: true)
    end

    before(:each) do
      expect(Tempfile).to receive(:new).with(%w(kitchen-localhost .ps1))
        .and_return(tempfile)
      expect(tempfile).to receive(:close)
      expect(tempfile).to receive(:unlink)
    end

    it 'writes the command to a temp file and executes it with PowerShell' do
      cmd = '"$env:TEMP"'
      expect(tempfile).to receive(:write).with(cmd)
      expect(tempfile).to receive(:path).and_return('/tmp/test.ps1')
      o = test_obj
      expect(o).to receive(:run_command_sh).with('powershell /tmp/test.ps1')
        .and_return('some output')
      expect(o.run_command_psh(cmd)).to eq('some output')
    end
  end

  describe '#cp_r' do
    let(:windows_os?) { nil }

    before(:each) do
      allow_any_instance_of(test_class).to receive(:windows_os?)
        .and_return(windows_os?)
    end

    context 'a non-Windows platform' do
      let(:windows_os?) { false }

      it 'calls cp_r with unaltered paths' do
        expect_any_instance_of(test_class).not_to receive(:run_command_psh)
        expect(FileUtils).to receive(:cp_r).with('/tmp/test1', '/tmp/test2')
        test_obj.cp_r('/tmp/test1', '/tmp/test2')
      end
    end

    context 'a Windows platform' do
      let(:windows_os?) { true }

      it 'calls PowerShell to resolve any variables' do
        expect_any_instance_of(test_class).to receive(:run_command_psh)
          .with('"$env:TEMP/test1"').and_return("/tmp/test1\n")
        expect_any_instance_of(test_class).to receive(:run_command_psh)
          .with('"$env:TEMP/test2"').and_return("/tmp/test2\n")
        expect(FileUtils).to receive(:cp_r).with('/tmp/test1', '/tmp/test2')
        test_obj.cp_r('$env:TEMP/test1', '$env:TEMP/test2')
      end
    end
  end

  describe '#rm_rf' do
    let(:windows_os?) { nil }

    before(:each) do
      allow_any_instance_of(test_class).to receive(:windows_os?)
        .and_return(windows_os?)
    end

    context 'a non-Windows platform' do
      let(:windows_os?) { false }

      it 'calls rm_rf with an unaltered path' do
        expect_any_instance_of(test_class).not_to receive(:run_command_psh)
        expect(FileUtils).to receive(:rm_rf).with('/tmp/test')
        test_obj.rm_rf('/tmp/test')
      end
    end

    context 'a Windows platform' do
      let(:windows_os?) { true }

      it 'calls PowerShell to resolve any variables' do
        expect_any_instance_of(test_class).to receive(:run_command_psh)
          .with('"$env:TEMP/test"').and_return("/tmp/test\n")
        expect(FileUtils).to receive(:rm_rf).with('/tmp/test')
        test_obj.rm_rf('$env:TEMP/test')
      end
    end
  end

  describe '#mkdir_p' do
    let(:windows_os?) { nil }

    before(:each) do
      allow_any_instance_of(test_class).to receive(:windows_os?)
        .and_return(windows_os?)
    end

    context 'a non-Windows platform' do
      let(:windows_os?) { false }

      it 'calls mkdir with an unaltered path' do
        expect_any_instance_of(test_class).not_to receive(:run_command_psh)
        expect(FileUtils).to receive(:mkdir_p).with('/tmp/test')
        test_obj.mkdir_p('/tmp/test')
      end
    end

    context 'a Windows platform' do
      let(:windows_os?) { true }

      it 'calls PowerShell to resolve any variables' do
        expect_any_instance_of(test_class).to receive(:run_command_psh)
          .with('"$env:TEMP/test"').and_return("/tmp/test\n")
        expect(FileUtils).to receive(:mkdir_p).with('/tmp/test')
        test_obj.mkdir_p('$env:TEMP/test')
      end
    end
  end

  describe '#windows_os?' do
    let(:platform) { nil }

    before(:each) { stub_const('RUBY_PLATFORM', platform) }

    context 'a Windows platform' do
      let(:platform) { 'windows' }

      it 'returns true' do
        expect(test_obj.windows_os?).to eq(true)
      end
    end

    context 'a Linux platform' do
      let(:platform) { 'linux' }

      it 'returns false' do
        expect(test_obj.windows_os?).to eq(false)
      end
    end
  end
end
