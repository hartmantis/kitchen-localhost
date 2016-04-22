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
    end

    context 'a nil command' do
      let(:command) { nil }

      it 'returns immediately' do
        c = connection
        expect(c).not_to receive(:run_command)
        expect(c.execute(command)).to eq(nil)
      end
    end

    context 'a successful command' do
      let(:command) { 'pwd' }
      let(:res) { 'myself' }

      it 'executes the command in a clean Bundler environment' do
        c = connection
        expect(Bundler).to receive(:with_clean_env).and_yield
        expect(c).to receive(:run_command).with(command).and_return(res)
        expect(c.execute(command)).to eq(res)
      end
    end

    context 'a failing command' do
      let(:command) { 'pwd' }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:run_command)
          .with(command).and_raise(Kitchen::ShellOut::ShellCommandFailed, 'no')
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
        allow_any_instance_of(described_class).to receive(m).and_return(true)
      end
    end

    shared_examples_for 'any locals' do
      it 'creates the remote dir' do
        c = connection
        expect(c).to receive(:mkdir_p).with(remote)
        c.upload(locals, remote)
      end
    end

    context 'a single local' do
      let(:locals) { '/tmp/1' }

      it_behaves_like 'any locals'

      it 'copies the local file' do
        c = connection
        expect(c).to receive(:cp_r).with(locals, remote)
        c.upload(locals, remote)
      end
    end

    context 'a set of locals' do
      let(:locals) { %w(/tmp/1 /tmp/2 /tmp/3) }

      it_behaves_like 'any locals'

      it 'copies the local files' do
        c = connection
        locals.each { |l| expect(c).to receive(:cp_r).with(l, remote) }
        c.upload(locals, remote)
      end
    end
  end
end
