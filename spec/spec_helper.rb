ENV['RACK_ENV'] ||= 'test'
require 'dotenv'
Dotenv.load
require 'simplecov'
SimpleCov.start
require 'pry'
require_relative '../lib/frgnt.rb'
require 'webmock/rspec'
require 'vcr'
require_relative 'fixtures/redis_config'
require 'database_cleaner'
VCR.configure do |c|
  # c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups
  #allow more verbose output when running an individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end
  # Run specs in random order to surface order dependencies
  config.order = :random
  # Set-up for DatabaseCleaner
  config.before(:suite) do
    redis_connection = "redis://#{$redis_ns.client.host}:#{$redis_ns.client.port}/#{$redis_ns.client.db}"
    namespace = "#{$redis_ns.namespace}:*"
    DatabaseCleaner[:redis, {connection: redis_connection}].strategy = :truncation, { only: [namespace] }
  end
  # Actually run tests within the DatabaseCleaner.cleaning method
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  # Set-up for Frgnt::Store to be run before each test.
  # The inclusion of #reset_store ensures that no state is persisted between tests.
  config.before(:each) do
    Frgnt::Store.config do
      set_store :memory
      reset_store
      set_base 'EUR'
      logger Logger.new(File.expand_path("../../log/#{ENV['RACK_ENV']}.log",__FILE__),5, '9C4000'.hex)
    end
  end
end
