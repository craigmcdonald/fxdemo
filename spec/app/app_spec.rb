require 'spec_helper'
require_relative 'app_helper'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    FrgntApp
  end

  it "has the correct title" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/<title>FX-u-like<\/title>/)
  end

  it "has the react div" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/div data-react-class="ClientApp"/)
  end

  describe '/exchange' do
    let(:dir_path) { '../../fixtures/' }
    let(:file_name) { 'eurofxref-hist-90d.xml'}
    let(:file_path) { File.expand_path("#{dir_path}#{file_name}",__FILE__) }

    before do
      Frgnt::Store.fetch_from_file(file_path)
    end

    it "/exchange converts from base to counter" do
      get('/exchange?date=2017-07-11&base=HKD&counter=USD&amount=100',{},{ "CONTENT_TYPE" => "application/json" })
      expect(last_response).to be_ok
      json_body = JSON.parse(last_response.body)
      expect(json_body['counter']).to eq({"iso_4217"=>"USD", "amount"=>"12.80"})
    end

    it "/exchange returns an error for an invalid base" do
      get('/exchange?date=2017-07-11&base=FOO&counter=USD&amount=100',{},{ "CONTENT_TYPE" => "application/json" })
      expect(last_response).to_not be_ok
      json_body = JSON.parse(last_response.body)
      expect(json_body['error']).to eq("Invalid iso_4217: FOO.")
    end

    it "/exchange returns an error for an invalid date" do
      get('/exchange?date=07-11&base=HKD&counter=USD&amount=100',{},{ "CONTENT_TYPE" => "application/json" })
      expect(last_response).to_not be_ok
      json_body = JSON.parse(last_response.body)
      expect(json_body['error']).to eq("Rate missing for HKD on 07-11.")
    end

    it "/exchange returns an error for a missing date" do
      get('/exchange?date=''&base=HKD&counter=USD&amount=100',{},{ "CONTENT_TYPE" => "application/json" })
      expect(last_response).to_not be_ok
      json_body = JSON.parse(last_response.body)
      expect(json_body['error']).to eq("Missing or invalid param(s). Required: date, base, counter, amount.")
    end

    it "/exchange returns an error for an invalid currency" do
      get('/exchange?date=''&base=HKD&counter=USD&amount=undefined',{},{ "CONTENT_TYPE" => "application/json" })
      expect(last_response).to_not be_ok
      json_body = JSON.parse(last_response.body)
      expect(json_body['error']).to eq("Missing or invalid param(s). Required: date, base, counter, amount.")
    end

    it "/exchange returns an error for an invalid currency" do
      get('/exchange?date=''&base=HKD&counter=USD&amount=$100',{},{ "CONTENT_TYPE" => "application/json" })
      expect(last_response).to_not be_ok
      json_body = JSON.parse(last_response.body)
      expect(json_body['error']).to eq("Missing or invalid param(s). Required: date, base, counter, amount.")
    end

  end
end
