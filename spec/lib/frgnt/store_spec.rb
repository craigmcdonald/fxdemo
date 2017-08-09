require 'spec_helper'

describe Frgnt::Store do
  it { is_expected.to be_kind_of(Module) }

  it 'should forward .config to Currencies' do
    expect(Frgnt::Store::Currencies).to receive(:config)
    subject.config {}
  end

  it 'should forward .fetch to Fetch' do
    expect(Frgnt::Fetch).to receive(:fetch)
    subject.fetch
  end

  it 'should forward .list to Curencies' do
    expect(Frgnt::Store::Currencies).to receive(:list)
    subject.list
  end

end
