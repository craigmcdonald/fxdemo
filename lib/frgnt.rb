# Frgnt::Store.config do |secret|
#   set_store :redis, secret
# end
#
# Frgnt::Store.fetch
#
# Frgnt::Exchange.at(Date.today,'USD','GBP')
# returns a float.
module Frgnt;end
require_relative 'frgnt/errors'
require_relative 'frgnt/http'
require_relative 'frgnt/store'
require_relative 'frgnt/fetch'
require_relative 'frgnt/exchange'
