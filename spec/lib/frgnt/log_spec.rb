require 'spec_helper'

describe Frgnt::Log do

  subject { described_class }
  let(:logger) { Logger.new(STDOUT) }
  before { subject.logger(logger) }

  it 'should output foo to STDOUT' do
    expect { subject.log(1,'foo') }
    .to output(/foo/).to_stdout_from_any_process
  end

  it 'should be a Singleton' do
    expect { subject.new }.to raise_error(NoMethodError)
    obj1 = subject.instance
    obj2 = subject.instance
    expect(obj1).to be(obj2)
  end
end
