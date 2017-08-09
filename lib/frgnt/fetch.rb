module Frgnt
  class Fetch
    class << self

      def fetch
        Store::Currencies.batch_upsert(HTTP::Client.new.response)
      end

      def fetch_from_file(filepath)
        res = MultiXml.parse(File.read(filepath))
        Store::Currencies.batch_upsert(HTTP::Response.new(res,200))
      end
    end
  end
end
