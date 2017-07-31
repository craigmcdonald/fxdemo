module Frgnt
  module Store
    
    class << self
      extend Forwardable
      def_delegator :currencies, :config
      def_delegator :fetcher, :fetch

      private

      def currencies
        Currencies
      end

      def fetcher
        Frgnt::Fetch
      end
    end
  end
end

require_relative 'store/currencies'
require_relative 'store/currency'
require_relative 'store/iso_lookup'
