module Frgnt
  class Exchange

    class << self

      def at(date,base,counter)
        @date = date
        get_ex(get_rate(base),get_rate(counter))
      end

      private

      def get_ex(base,counter)
        (counter / base).round(5)
      end

      def get_rate(str)
        currency = str == 'EUR' ? 1.0 : Store::Currencies[str]
        rate = rate_from_currency(currency,str)
        validate_rate(rate,str)
      end

      def validate_rate(rate,str)
        return rate if rate && rate.is_a?(Float) && rate > 0.0
        raise ExchangeError.new("Rate missing for #{str} on #{@date.to_s}.")
      end

      def rate_from_currency(currency,str)
        return currency.rates[@date] if currency
        raise ExchangeError.new("Invalid iso_4217: #{str}.")
      end
    end
  end
end
