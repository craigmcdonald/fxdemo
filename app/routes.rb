module Sinatra
  module App
    module Routes

      def self.registered(app)
        app.get ?/ do
          content_type :html
          haml :'index', layout: true, locals: { list: list_of_currencies }
        end

        app.get '/exchange' do
          content_type :json
          args = params.values_at(*required_keys)
          pass unless valid_args(args)
          begin
            amount_in_counter(args)
          rescue Frgnt::ExchangeError => e
            status 400
            json_error(e.message)
          end
        end

        app.get '/exchange' do
          content_type :json
          status 400
          json_error("Missing or invalid param(s). Required: #{required_keys.join(', ')}.")
        end
      end
    end
  end
end
