require 'spec_helper'

describe Frgnt::Store::Currency do

  describe 'with a first rate' do
    let(:iso_4217) { 'USD'}
    let(:date) { Date.parse('2017-01-01') }
    let(:rate) { '1.1654' }
    subject { described_class.new(iso_4217).add_rate(date,rate) }

    it 'should have a #name of US Dollar' do
      expect(subject.name).to eq('US Dollar')
    end

    it 'should have a #iso_4217 of USD' do
      expect(subject.iso_4217).to eq('USD')
    end

    it 'should have a #rates hash with a date of 2017-01-01 and a rate of 1.1654' do
      expect(subject.rate_at('2017-01-01')).to eq(1.1654)
    end

    it 'should recurse to the first valid date when #rate_at includes 2nd arg of true' do
      expect(subject.rate_at('2017-01-02',true)).to eq(1.1654)
    end

    it 'should recurse 3 times when a 3rd of arg of 3 is included' do
      expect(subject.rate_at('2017-01-02',true,3)).to eq(1.1654)
      expect(subject.rate_at('2017-01-03',true,3)).to eq(1.1654)
      expect(subject.rate_at('2017-01-04',true,3)).to eq(1.1654)
      expect(subject.rate_at('2017-01-05',true,3)).to eq(nil)
    end

    it 'should raise Frgnt::DateError for an invalid date' do
      msg = "Argument for date is not a valid date: foo."
      expect { subject.rate_at('foo',true,3) }.to raise_error(Frgnt::DateError,msg)
    end

    describe 'adding a second rate with #add_rate' do
      let(:rate2) { '1.1754' }
      let(:date2) { Date.parse('2017-01-02') }

      it 'should have a #rates hash with two dates and rates' do
        subject
        subject.add_rate(date2,rate2)
        expect(subject.rate_at('2017-01-01')).to eq(1.1654)
        expect(subject.rate_at('2017-01-02')).to eq(1.1754)
      end
    end
  end
end
