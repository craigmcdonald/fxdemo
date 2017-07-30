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
        if currency
          currency.rates[@date]
        else
          raise StandardError.new("Invalid iso_4217: #{str}")
        end
      end
    end
  end
end
