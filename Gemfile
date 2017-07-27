ruby '2.4.1'

source 'https://rubygems.org' do
  # HTTP Client lib
  gem 'faraday'
  # Persistence for the Currency Conversions
  gem 'redis-objects'
  gem 'redis-namespace'

  group :development, :test do
    gem 'rspec'
    gem 'pry-byebug'
    gem 'dotenv'
  end

  group :test do
    gem 'webmock'
    gem 'vcr'
    gem 'database_cleaner'
  end
end
