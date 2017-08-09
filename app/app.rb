require 'logger'
require './lib/frgnt'
require './app/helpers'
require './app/routes'

# Config for the app if it is not running in RACK_ENV=test (in which case spec/spec_helper.rb
# and spec/app/app_helper.rb handle it).
unless ENV['RACK_ENV'] == 'test'
  # Redis config
  dir_path = '../../db/'
  file_name = 'redis.yml'
  file_path = File.expand_path("#{dir_path}#{file_name}",__FILE__)
  REDIS_CONFIG = YAML.load( File.open(file_path)).transform_keys_to_symbols
  default = REDIS_CONFIG[:default]
  config = default.merge(REDIS_CONFIG[ENV['RACK_ENV'].to_sym])
  $redis = Redis.new(config)
  $redis_ns = Redis::Namespace.new(config[:namespace], :redis => $redis) if config[:namespace]
  Redis::Objects.redis = $redis_ns
  # Make sure you set ENV['STORE_SECRET'] to be a unique-ish string, otherwise this will
  # throw an error.
  Frgnt::Store.config do
    set_store :redis, ENV['STORE_SECRET']
    set_base 'EUR'
    logger Logger.new(File.expand_path("../../log/#{ENV['RACK_ENV']}.log",__FILE__),5, '9C4000'.hex)
  end
  # If you don't want the app to fetch from the ECB website, then set ENV['NO_FETCH'] to true.
  # It will use a file downloaded on the 8/8/2017. This is just for offline development.
  unless ENV['NO_FETCH']
    Frgnt::Store.fetch
  else
    Frgnt::Store.fetch_from_file(File.expand_path('../../db/eurofxref-hist-90d.xml',__FILE__))
  end
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
