require_relative '../../../lib/op'

RSpec.describe Op::Response do
  context '#initialize' do
    subject { -> { described_class.new(args) } }

    context 'with no args' do
      subject { -> { described_class.new } }
      it { expect(subject).to raise_error(ArgumentError) }
    end

    context ':status arg' do
      context 'with no :status arg' do
        let(:args) { { messages: ['message'], value: 'string' } }
        it { expect(subject).to raise_error(ArgumentError) }
      end

      context 'with invalid :status arg' do
        let(:args) { { status: status } }
        let(:status) { 'wrong status' }

        it do
          error_class   = Op::Response::InvalidStatusError
          error_message = 'Invalid status (status=wrong status), has to be in [error, ok])'
          expect(subject).to raise_error(error_class, error_message)
        end
      end

      context 'with valid :status arg and no other args' do
        let(:args) { { status: status } }
        let(:status) { :ok }

        it { expect(subject).to_not raise_error }

        context 'with :status => :ok arg' do
          let(:status) { :ok }
          it { expect(subject.call).to be_ok }
        end

        context 'with :status => "ok" arg' do
          let(:status) { 'ok' }
          it { expect(subject.call).to be_ok }
        end

        context 'with :status => :error arg' do
          let(:status) { :error }
          it { expect(subject.call).to be_error }
        end

        context 'with :status => "error" arg' do
          let(:status) { 'error' }
          it { expect(subject.call).to be_error }
        end
      end
    end
  end
end
