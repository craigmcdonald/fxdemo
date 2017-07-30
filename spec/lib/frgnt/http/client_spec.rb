require 'spec_helper'

describe Frgnt::HTTP::Client do
  subject { Frgnt::HTTP::Client.new }

  it {is_expected.to respond_to(:get) }
  it {is_expected.to respond_to(:response) }

  describe '#response', :vcr do

    it 'should cache the initial response' do
      first_id = subject.response.object_id
      second_id = subject.response.object_id
      expect(first_id).to eq(second_id)
    end

    it 'should return a status' do
      expect(subject.response.status).to be_kind_of(Integer)
    end

    it 'should return a body' do
      expect(subject.response.body).to be_kind_of(Array)
    end

    describe 'web server timeout' do
      before { stub_request(:any,ENV['ECB_URL']).to_timeout }

      it 'should return a status of 504' do
        expect(subject.response.status).to eq(504)
      end

      it 'should return a body of {error: "execution expired"}' do
        expect(subject.response.errors[0]).to eq('execution expired')
      end
    end

    describe 'not found' do
      before { stub_request(:any,ENV['ECB_URL']).to_return(body:'', status:404) }

      it 'should return a status of 404' do
        expect(subject.response.status).to eq(404)
      end

      it 'should return a body of {error: "the server responded with status 404"}' do
        msg = 'the server responded with status 404'
        expect(subject.response.errors[0]).to eq(msg)
      end
    end

    describe 'invalid xml body' do
      let(:headers) { {'Content-Type' => 'application/xml'}}
      before { stub_request(:any,ENV['ECB_URL']).to_return(body:'<notxml', status: 200, headers: headers) }

      it 'should return a status of 500' do
        expect(subject.response.status).to eq(500)
      end

      it 'should return a body of {error: "...Couldn\'t find end of Start Tag.."}' do
        expect(subject.response.errors[0]).to match(/Couldn't find end of Start Tag/)
      end
    end

    describe 'raising an uncaught error' do

      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(StandardError.new)
      end

      it 'should raise an error' do
        expect { subject.response }.to raise_error(StandardError)
      end
    end
  end
end
