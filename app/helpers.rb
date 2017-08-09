module Sinatra
  module App
    module Helpers

      def list_of_currencies
        Frgnt::Store.list.map {|d| {'label' => d[1], 'value' => d[0] }}
      end

      def required_keys
        ['date','base','counter','amount']
      end

      def valid_args(args)
        without_undefined = args - ["undefined"]
        valid_date(args[0]) && without_undefined.compact.count == 4
      end

      def valid_date(date)
        !!Date.parse(date)
      rescue ArgumentError
        false
      end

      def amount_in_counter(args)
        amount = args.pop
        exr = Frgnt::Exchange.at(*args,true)
        exchange_result(amount,*args,(amount.to_f * exr).round(2))
      end

      def exchange_result(amount_in_base, date, base, counter, amount_in_counter)
        {
          date: date,
          base: {
            iso_4217: base,
            amount: format("%.2f",amount_in_base)
          },
          counter: {
            iso_4217: counter,
            amount: format("%.2f",amount_in_counter)
          }
        }.to_json
      end

      def json_error(msg)
        {error: msg}.to_json
      end
    end
  end
end
