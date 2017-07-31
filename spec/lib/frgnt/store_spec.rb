require 'spec_helper'

describe Frgnt::Store do
  it { is_expected.to be_kind_of(Module) }

  it 'should forward .config to Currencies' do
    expect(Frgnt::Store::Currencies).to receive(:config)
    subject.config do
      set_store :memory
    end
  end

  it 'should forward .fetch_currencies to Fetch' do
    expect(Frgnt::Fetch).to receive(:fetch)
    subject.fetch
  end
end
