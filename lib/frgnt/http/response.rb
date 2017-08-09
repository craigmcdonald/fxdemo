module Frgnt
  module HTTP
    class Response
      attr_reader :status, :errors

      def initialize(obj={},status=200)
        @idx,@currency_idx,@errors = 0,0,[]
        @obj,@status= obj,status
        body && self
      end

      def body
        @body ||= data.map.with_index do |daily_rate, idx|
          @idx = idx
          OpenStruct.new.tap do |os|
            os.date = fetch_date(daily_rate) || ""
            os.currencies = fetch_currencies(daily_rate) || []
          end
        end
      end

      private

      def data
        return @obj['Envelope']['Cube']['Cube'] if @obj['Envelope'] &&
        @obj['Envelope']['Cube'] &&
        @obj['Envelope']['Cube']['Cube']
        return return_error(:data) || []
      end

      def fetch_currencies(hash)
        currencies = hash.fetch!('Cube') { return return_error(:currencies) }
        return return_error(:currencies) unless valid_currencies(currencies)
        currencies.map.with_index do |currency,idx|
          @currency_idx = idx
          OpenStruct.new.tap do |os|
            os.iso_4217 = currency.fetch!('currency') { return_error(:iso_4217) || "" }
            os.rate = currency.fetch!('rate') { return_error(:rate) || "" }
          end
        end
      end

      def valid_currencies(currencies)
        currencies.map do |currency|
          ['currency', 'rate'].all? {|k| currency.has_key?(k) }
        end.all? {|res| res }
      end

      def fetch_date(hash)
        date = hash.fetch!('time') { return return_error(:time) }
        Date.parse(date)
      rescue ArgumentError
        return_error(:date)
      end

      def return_error(sym)
        msg = "Invalid Data: ['Envelope']['Cube']['Cube'][#{@idx}]" + case sym
        when :data then " must be present."
        when :time then "['time'] must be present and not nil."
        when :date then "['time'] must be a valid date in the format YYYY-MM-DD."
        when :currencies then "['Cube'] must be present and not nil."
        when :iso_4217 then "['Cube'][#{@currency_idx}]['currency'] must be present and not nil."
        when :rate then "['Cube'][#{@currency_idx}]['rate'] must be present and not nil."
        end
        @errors << msg
        @body = []
        nil
      end
    end
  end
end
