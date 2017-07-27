ruby '2.4.1'

source 'https://rubygems.org' do
  # HTTP Client lib
  gem 'faraday'
  gem 'faraday_middleware'
  gem 'multi_xml'
  # Persistence for the Currency Conversions
  gem 'redis-objects'
  gem 'redis-namespace'

  group :development do
     gem 'guard-rspec', require: false
  end

  group :development, :test do
    gem 'rspec'
    gem 'pry-byebug'
    gem 'dotenv'
  end

  group :test do
    gem 'webmock'
    gem 'vcr'
    gem 'database_cleaner'
    gem 'simplecov'
  end
end
