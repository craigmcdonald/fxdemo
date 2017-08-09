module Frgnt
  module Store

    class << self
      extend Forwardable
      def_delegators :currencies, :config, :list, :logger, :reset_store
      def_delegators :fetcher, :fetch, :fetch_from_file

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
require_relative 'store/base_currency'
require_relative 'store/iso_lookup'
