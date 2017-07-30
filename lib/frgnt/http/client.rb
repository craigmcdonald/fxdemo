require 'faraday'
require 'faraday_middleware'
require 'forwardable'
require 'ostruct' unless defined?(OStruct)
module Frgnt
  module HTTP
    class Client
      extend Forwardable
      def_delegator :@connection, :get

      def initialize(url=ENV['ECB_URL'],response_class=Response)
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
        @response_class.new(get)
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
