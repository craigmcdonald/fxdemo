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
require 'redis-objects'
require 'redis-namespace'

module Frgnt;end
require_relative 'frgnt/log'
require_relative 'frgnt/errors'
require_relative 'frgnt/http'
require_relative 'frgnt/store'
require_relative 'frgnt/fetch'
require_relative 'frgnt/exchange'
