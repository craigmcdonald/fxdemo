require 'spec_helper'

describe Frgnt::Store::Currencies do

  subject { described_class }

  describe '.config' do

    it 'should set the store to :memory' do
      expect(subject).to receive(:set_store).with(:memory)
      expect(subject).to receive(:set_base).with('EUR')
      subject.config do
        set_store :memory
        set_base 'EUR'
      end
    end
  end

  describe '.[] and .[]=' do

     before do
       subject['foo'] = 'bar'
     end

     it 'should return bar for ["foo"]' do
       expect(subject['foo']).to eq('bar')
     end

     it 'should return baz for ["foo"]' do
       subject['foo'] = 'baz'
       expect(subject['foo']).to eq('baz')
     end
  end

  describe '.list' do

    before do
      subject['FOO'] = OpenStruct.new(name: 'bar')
      subject['BAZ'] = OpenStruct.new(name: 'qux')
      subject['UQ']  = OpenStruct.new(name: '42')
    end

    it 'should return a sorted array of keys and names' do
      ary = [['BAZ','qux'],["EUR", "Euro"],['FOO','bar'],['UQ','42']]
      expect(subject.list).to eq(ary)
    end

  end

  describe 'with redis' do

    let(:secret) { SecureRandom.uuid }

    it 'should return bar for ["foo"]' do

      subject.config do |secret|
        set_store :redis, secret
        set_base 'EUR'
      end

      subject['foo'] = 'bar'
      expect(subject['foo']).to eq('bar')
    end
  end

  describe 'with invalid store' do
    let(:msg) { "Store type: mongodb has not been implemented." }

    it 'should raise NotImplemented error' do
      expect do
        subject.config do
          reset_store
          set_store :mongodb
        end
      end.to raise_error(Frgnt::StoreTypeNotImplemented,msg)
    end
  end

  describe '.batch_upsert' do
    subject { described_class }
    let(:dir_path) { '../../../../fixtures/' }
    let(:file_name) { 'eurofxref-hist-2d-usd-gbp.xml'}
    let(:file_path) { File.expand_path("#{dir_path}#{file_name}",__FILE__) }
    let(:file) { File.open(file_path) }
    let(:xml) { MultiXml.parse(file.read) }
    let(:response) { Frgnt::HTTP::Response.new(xml,200) }

    it 'should create all the currencies and rates' do
      subject.batch_upsert(response)
      usd = Frgnt::Store::Currencies.find('USD')
      expect(usd.name).to eq('US Dollar')
      expect(usd.iso_4217).to eq('USD')
      expect(usd.rate_at('2017-07-27')).to be_within(0.1).of(1.1694)
    end
  end

end
