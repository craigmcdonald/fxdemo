require 'spec_helper'
require 'ostruct' unless defined?(OpenStruct)
require 'date' unless defined?(Date)

describe Frgnt::Store::Currency do

  Frgnt::Store.config do
    set_store :memory
  end

  describe 'with a first rate' do
    let(:currency) { OpenStruct.new(iso_4217: 'USD', rate: '1.1654') }
    subject { described_class.new(Date.parse('2017-01-01'),currency) }

    it 'should have a #name of US Dollar' do
      expect(subject.name).to eq('US Dollar')
    end

    it 'should have a #iso_4217 of USD' do
      expect(subject.iso_4217).to eq('USD')
    end

    it 'should have a #rates hash with a date of 2017-01-01 and a rate of 1.1654' do
      expect(subject.rates[Date.parse('2017-01-01')]).to eq(1.1654)
    end

    describe 'with a second rate' do
      let(:currency2) { OpenStruct.new(iso_4217: 'USD', rate: '1.1754') }

      it 'should have a #rates hash with two dates and rates' do
        subject
        described_class.new(Date.parse('2017-01-02'),currency2)
        expect(subject.rates[Date.parse('2017-01-01')]).to eq(1.1654)
        expect(subject.rates[Date.parse('2017-01-02')]).to eq(1.1754)
      end
    end
  end

  describe '.factory' do
    subject { described_class }
    let(:dir_path) { '../../../../fixtures/' }
    let(:file_name) { 'eurofxref-hist-90d.xml'}
    let(:file_path) { File.expand_path("#{dir_path}#{file_name}",__FILE__) }
    let(:file) { File.open(file_path) }
    let(:xml) { MultiXml.parse(file.read) }
    let(:response) { Frgnt::HTTP::Response.new(xml,200) }

    it 'should create all the currencies and rates' do
      subject.factory(response)
      expect(Frgnt::Store::Currencies['USD'].name).to eq('US Dollar')
    end
  end
end
