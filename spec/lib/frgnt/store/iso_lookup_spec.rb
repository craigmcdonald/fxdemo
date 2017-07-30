require 'spec_helper'

describe Frgnt::Store::ISOLookup do

  subject { described_class }

  it 'should load the asset file' do
    expect(subject::XML).to be_kind_of(Hash)
  end

  it 'should load the asset file once' do
    obj1 = subject::XML.object_id
    obj2 = subject::XML.object_id
    expect(obj1).to eq(obj2)
  end

  it 'should return US Dollar for USD' do
    expect(subject.find('USD')).to eq('US Dollar')
  end

  it 'should return the empty string for ABC' do
    expect(subject.find('ABC')).to eq('')
  end
end
