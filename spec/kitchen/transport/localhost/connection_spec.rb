# Encoding: UTF-8

require_relative '../../../spec_helper'
require_relative '../../../../lib/kitchen/transport/localhost/connection'

describe Kitchen::Transport::Localhost::Connection do
  let(:logger) { double(info: true, debug: true) }
  let(:connection) { described_class.new }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:logger)
      .and_return(logger)
  end

  describe '#execute' do
    let(:command) { nil }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:run_command)
        .and_return(true)
    end

    context 'a nil command' do
      let(:command) { nil }

      it 'returns immediately' do
        expect_any_instance_of(described_class).not_to receive(:run_command)
        expect(connection.execute(command)).to eq(nil)
      end
    end

    context 'a successful command' do
      let(:command) { 'pwd' }
      let(:res) { 'myself' }

      it 'executes the command' do
        expect_any_instance_of(described_class).to receive(:run_command)
          .with(command).and_return(res)
        expect(connection.execute(command)).to eq(res)
      end
    end

    context 'a failing command' do
      let(:command) { 'pwd' }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:run_command)
          .with(command).and_raise(Kitchen::ShellOut::ShellCommandFailed)
      end

      it 're-raises the exception' do
        expected = Kitchen::Transport::LocalhostFailed
        expect { connection.execute(command) }.to raise_error(expected)
      end
    end
  end

  describe '#upload' do
    let(:locals) { nil }
    let(:remote) { '/tmp/kitchen' }

    before(:each) do
      %i(mkdir_p cp_r).each do |m|
        allow(FileUtils).to receive(m).and_return(true)
      end
    end

    shared_examples_for 'any locals' do
      it 'creates the remote dir' do
        expect(FileUtils).to receive(:mkdir_p).with(remote)
        connection.upload(locals, remote)
      end
    end

    context 'a single local' do
      let(:locals) { '/tmp/1' }

      it_behaves_like 'any locals'

      it 'copies the local file' do
        expect(FileUtils).to receive(:cp_r).with(locals, remote)
        connection.upload(locals, remote)
      end
    end

    context 'a set of locals' do
      let(:locals) { %w(/tmp/1 /tmp/2 /tmp/3) }

      it_behaves_like 'any locals'

      it 'copies the local files' do
        locals.each do |l|
          expect(FileUtils).to receive(:cp_r).with(l, remote)
        end
        connection.upload(locals, remote)
      end
    end
  end
end
