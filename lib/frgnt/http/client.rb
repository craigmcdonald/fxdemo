module Frgnt
  module HTTP
    class Client
      extend Forwardable
      def_delegator :@connection, :get

      ECB_URL = ENV['ECB_URL'] || 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'

      def initialize(url=ECB_URL,response_class=Response)
        @response_class = response_class
        @connection = Faraday.new url do |conn|
          conn.response :raise_error
          conn.response :xml,  :content_type => /\bxml$/
          conn.adapter Faraday.default_adapter
        end
      end

      def response
        @response ||= get_with_error_handling
      end

      private

      def get_with_error_handling
        faraday_res = get
        @response_class.new(faraday_res.body,faraday_res.status)
      rescue => e
        status = case e
        when Faraday::ResourceNotFound then 404
        when Faraday::ConnectionFailed then 504
        when Faraday::ParsingError then 500
        else
          raise e
        end
        OpenStruct.new.tap do |os|
          os.status = status
          os.body = []
          os.errors = [e.message]
        end
      end
    end
  end
end
