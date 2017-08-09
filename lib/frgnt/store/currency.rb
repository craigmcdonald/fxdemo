module Frgnt
  module Store
    class Currency
      attr_reader :name, :iso_4217, :rates

      class << self
        def find_or_initialize_by(str)
          iso_4217 = str.upcase
          Currencies[iso_4217] || new(iso_4217)
        end
      end

      def initialize(iso_4217)
        @name = ISOLookup.find(iso_4217)
        @iso_4217 = iso_4217
        @rates = {}
      end

      def add_rate(date,rate)
        @rates[date] = rate.to_f
        self
      end

      def rate_at(date,nearest=false,tries=10)
        date = parse_date(date)
        rate = @rates[date]
        if !rate && nearest && tries > 0
          date -= 1
          tries -= 1
          rate_at(date,true,tries)
        else
          rate
        end
      end

      private
      def parse_date(date)
        Date.parse(date.to_s)
      rescue ArgumentError
        raise Frgnt::DateError.new("Argument for date is not a valid date: #{date}.")
      end
    end
  end
end
