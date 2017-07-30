require 'spec_helper'

describe Frgnt::Exchange do

  subject { described_class }
  let(:dir_path) { '../../../fixtures/' }
  let(:file_name) { 'eurofxref-hist-90d.xml'}
  let(:file_path) { File.expand_path("#{dir_path}#{file_name}",__FILE__) }
  let(:file) { File.open(file_path) }
  let(:xml) { MultiXml.parse(file.read) }
  let(:response) { Frgnt::HTTP::Response.new(xml,200) }

  before do
    Frgnt::Store.config do
      set_store :memory
    end
    Frgnt::Store::Currency.factory(response)
  end

  after { Frgnt::Store::Currencies.config { set_store :memory } }

  describe "#at" do

    it 'should be within 0.01 of 0.76089 for USD -> GBP on 27/7/17' do
      expect(subject.at(Date.parse('2017-07-27'),'USD','GBP')).to be_within(0.01).of(0.76089)
    end

    it 'should be within 0.01 of 1.31426 for GBP -> USD on 27/7/17' do
      expect(subject.at(Date.parse('2017-07-27'),'GBP','USD')).to be_within(0.01).of(1.31426)
    end
  end
end
