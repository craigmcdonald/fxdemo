require 'spec_helper'

describe Frgnt::Store::BaseCurrency do

  subject { described_class.new('USD') }

  it { is_expected.to receive(:name).and_return('US Dollar'); subject.name }
  it { is_expected.to receive(:iso_4217).and_return('USD'); subject.iso_4217 }

  let(:msg) do
    <<~ERR
      BaseCurrency#add_rate is disabled as objects of this class will always
      return a rate of 1.0. You attempted to call #add_rate with args:
      2017-07-27, 2.0.
    ERR
  end

  it 'should raise Frgnt::NoMethodError if #add_rate is called' do
    expect { subject.add_rate('2017-07-27','2.0')}
    .to raise_error(Frgnt::NoMethodError,msg)
  end

  describe '#rate_at' do
    let(:day) { rand(1..28) }
    let(:month) { rand(1..12) }
    let(:year) { 4.times { rand(0..9) } }
    let(:date) { "#{year}-#{month}-#{day}"}

    it 'should return 1.0 for any date' do
      expect(subject.rate_at(date)).to eq(1.0)
    end
  end
end
