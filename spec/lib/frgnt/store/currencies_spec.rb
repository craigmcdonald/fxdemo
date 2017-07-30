require 'spec_helper'

describe Frgnt::Store::Currencies do

  subject { described_class }

  describe '.config' do

    it 'should set the store to :memory' do
      expect(subject).to receive(:set_store).with(:memory)
      subject.config do
        set_store :memory
      end
    end
  end

  describe '#[] and #[]=' do

     before do
       subject.config do
         set_store :memory
       end
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

  describe 'with redis' do

    after { Frgnt::Store::Currencies.config { set_store :memory } }
    let(:secret) { SecureRandom.uuid }

    it 'should return bar for ["foo"]' do

      subject.config do |secret|
        set_store :redis, secret
      end

      subject['foo'] = 'bar'
      expect(subject['foo']).to eq('bar')
    end
  end
end
