module Frgnt
  class Exchange
    class << self
      def at(date,base,counter,nearest=false,tries=10)
        @date, @nearest,@tries = date,nearest,tries
        get_ex(get_rate(base),get_rate(counter))
      end

      private

      def get_ex(base,counter)
        (counter / base).round(5)
      end

      def get_rate(str)
        rate = rate_from_currency(str)
        validate_rate(rate,str)
      end

      def validate_rate(rate,str)
        return rate if rate && rate.is_a?(Float) && rate > 0.0
        raise ExchangeError.new("Rate missing for #{str} on #{@date.to_s}.")
      end

      def rate_from_currency(str)
        currency = Store::Currencies.find(str)
        return currency.rate_at(@date,@nearest,@tries) if currency
        raise ExchangeError.new("Invalid iso_4217: #{str}.")
      end
    end
  end
end
