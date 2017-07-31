require 'forwardable' unless defined?(Forwardable)
module Frgnt
  module Store
    class Currency
      class << self
        
        def factory(response)
          response.body.each do |os|
            os.currencies.each do |currency|
              self.new(os.date,currency)
            end
          end
        end
      end

      extend Forwardable
      def_delegators :@store, :name, :iso_4217, :rates

      def initialize(date,currency)
        @store = Currencies[currency.iso_4217] || OpenStruct.new.tap do |os|
          os.name = ISOLookup.find(currency.iso_4217)
          os.iso_4217 = currency.iso_4217
          os.rates = {}
        end
        @store.rates[date] = currency.rate.to_f
        Currencies[currency.iso_4217] = @store
      end
    end
  end
end
