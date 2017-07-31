module Frgnt
  class Fetch
    class << self

      def fetch
        Store::Currency.factory(HTTP::Client.new.response)
      end
    end
  end
end
