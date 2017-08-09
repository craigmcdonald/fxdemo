require 'spec_helper'

describe Frgnt::Fetch do

  subject { described_class }
  let(:secret) { SecureRandom.uuid }
  let(:dir_path) { '../../../fixtures/' }
  let(:file_name) { 'eurofxref-hist-2d-usd-gbp.xml'}
  let(:file_path) { File.expand_path("#{dir_path}#{file_name}",__FILE__) }

  before do
    Frgnt::Store::Currencies.send('reset_store')
    Frgnt::Store.config do |secret|
      set_store :redis, secret
      set_base 'EUR'
    end
  end

  it 'should populate a store with .fetch', :vcr do
    subject.fetch
    expect(Frgnt::Exchange.at('2017-07-27','USD','GBP'))
    .to be_within(0.01).of(0.76089)
  end

  it 'should populate a store with .fetch_from_file', :vcr do
    subject.fetch_from_file(file_path)
    expect(Frgnt::Exchange.at('2017-07-27','USD','GBP'))
    .to be_within(0.01).of(0.76089)
  end
end
