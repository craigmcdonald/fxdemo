require 'logger'
require './lib/frgnt'
require './app/helpers'
require './app/routes'

Frgnt::Store.config do
  set_store :redis, ENV['STORE_SECRET']
  reset_store ENV['RACK_ENV'] != 'production'
  set_base 'EUR'
  logger Logger.new(File.expand_path("../../log/#{ENV['RACK_ENV']}.log",__FILE__),5, '9C4000'.hex)
end

if ENV['RACK_ENV'] == 'production'
  Frgnt::Store.fetch
else
  Frgnt::Store.fetch_from_file(File.expand_path('../../db/eurofxref-hist-90d.xml',__FILE__))
end

class FrgntApp < Sinatra::Base

  register React::Sinatra

  configure do
    React::Sinatra.configure do |config|
      config.use_bundled_react = true
      config.env = ENV['RACK_ENV'].to_sym
      config.runtime      = :execjs
      config.asset_path   = %w(client/dist/server.js)
      config.pool_size    = 5
      config.pool_timeout = 10
    end

    React::Sinatra::Pool.pool.reset
  end

  set :views, File.join(__dir__, 'views')
  set :public_folder, 'public'

  helpers Sinatra::App::Helpers
  register Sinatra::App::Routes
end
