# Std-lib dependencies
require 'forwardable' unless defined?(Forwardable)
require 'ostruct' unless defined?(OStruct)
require 'date' unless defined?(Date)
require 'singleton' unless defined?(Singleton)
require 'logger' unless defined?(Logger)
# Gem dependencies
require 'faraday'
require 'faraday_middleware'
require 'redis-objects'
require 'multi_xml'

# Frgnt::Store.config do |secret|
#  logger Logger.new(STDOUT)
#  set_store :redis, secret
# end
#
# Frgnt::Store.fetch
# Frngt::Store.fetch_from_file(<filepath>)
#
# Frgnt::Store.list
# returns a sorted list of currencies
#
# Frgnt::Exchange.at(Date.today,'USD','GBP',true)
# returns a float.
# passing true at the end of the args will force the method
# to recurse until it finds a valid date (useful for weekends)
# up to 10 times (although this can be overriden by passing in an interger
# after true.
module Frgnt;end
require_relative 'frgnt/log'
require_relative 'frgnt/errors'
require_relative 'frgnt/http'
require_relative 'frgnt/store'
require_relative 'frgnt/fetch'
require_relative 'frgnt/exchange'
