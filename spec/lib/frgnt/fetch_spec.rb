require 'spec_helper'

describe Frgnt::Fetch do

  subject { described_class }
  let(:secret) { SecureRandom.uuid }

  before do
    Frgnt::Store.config do |secret|
      set_store :redis, secret
    end
  end

  it 'should populate a store with .fetch', :vcr do
    subject.fetch
    expect(Frgnt::Exchange.at(Date.parse('2017-07-27'),'USD','GBP'))
    .to be_within(0.01).of(0.76089)
  end
end
