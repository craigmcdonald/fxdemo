require 'spec_helper'
require 'multi_xml'

describe Frgnt::HTTP::Response do

  subject { described_class.new }

  it { is_expected.to respond_to(:body) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:errors) }

  describe "#daily_rates" do
    let(:dir_path) { '../../../../fixtures/' }
    let(:file_name) { 'eurofxref-hist-90d.xml'}
    let(:file_path) { File.expand_path("#{dir_path}#{file_name}",__FILE__) }
    let(:file) { File.open(file_path) }
    let(:xml) { MultiXml.parse(file.read) }
    let(:response) { described_class.new(xml,200) }

    it 'should return an Array of OpenStructs' do
      expect(response.body).to be_kind_of(Array)
    end

    it 'the first OpenStruct should have a date' do
      expect(response.body.first.date).to eq(Date.parse('2017-07-27'))
    end

    it 'the first OpenStruct should contain an array of OpenStructs at #currencies' do
      currencies = response.body.first.currencies
      expect(currencies).to be_kind_of(Array)
      expect(currencies.first).to be_kind_of(OpenStruct)
      expect(currencies.first).to respond_to(:iso_4217)
      expect(currencies.first).to respond_to(:rate)
    end

    describe "date missing" do
      let(:file_name) { 'eurofxref-hist-90d_error_date.xml' }
      it 'should return an error msg' do
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][1]['time'] must be present and not nil."
        expect(response.errors[0]).to eq(msg)
        expect(response.body[1].date).to eq("")
      end
    end

    describe "date invalid" do
      let(:file_name) { 'eurofxref-hist-90d_invalid_date.xml' }
      it 'should return an error msg' do
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][1]['time'] must be a valid date in the format YYYY-MM-DD."
        expect(response.errors[0]).to eq(msg)
        expect(response.body[1].date).to eq("")
      end
    end

    describe "date empty" do
      let(:file_name) { 'eurofxref-hist-90d_empty_date.xml' }
      it 'should return an error msg' do
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][1]['time'] must be present and not nil."
        expect(response.errors[0]).to eq(msg)
        expect(response.body[1].date).to eq("")
      end
    end

    describe "error with currencies" do
      let(:file_name) { 'eurofxref-hist-90d_error_currencies.xml' }
      it 'should return an error msg' do
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][1]['Cube'] must be present and not nil."
        expect(response.errors[0]).to eq(msg)
        expect(response.body[1].currencies).to eq([])
      end
    end

    describe "error with currency name" do
      let(:file_name) { 'eurofxref-hist-90d_error_currency_name.xml' }
      it 'should return an error msg' do
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][1]['Cube'][0]['currency'] must be present and not nil."
        expect(response.errors[0]).to eq(msg)
        expect(response.body[1].currencies[0].iso_4217).to eq("")
      end
    end

    describe "error with currency rate" do
      let(:file_name) { 'eurofxref-hist-90d_error_currency_rate.xml' }
      it 'should return an error msg' do
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][1]['Cube'][0]['rate'] must be present and not nil."
        expect(response.errors[0]).to eq(msg)
        expect(response.body[1].currencies[0].rate).to eq("")
      end
    end

    describe "multiple errors" do
      let(:file_name) { 'eurofxref-hist-90d_multiple_errors.xml' }
      it 'should return an error msg' do
        msgs = [
          "Invalid Data: ['Envelope']['Cube']['Cube'][1]['Cube'][0]['currency'] must be present and not nil.",
          "Invalid Data: ['Envelope']['Cube']['Cube'][2]['Cube'][0]['rate'] must be present and not nil.",
          "Invalid Data: ['Envelope']['Cube']['Cube'][3]['time'] must be present and not nil."
        ]
        expect(response.errors).to eq(msgs)
      end
    end
  end
end
