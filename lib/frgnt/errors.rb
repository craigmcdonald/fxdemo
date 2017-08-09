module Frgnt
  ExchangeError = Class.new(StandardError)
  StoreTypeNotImplemented = Class.new(NotImplementedError)
  NoMethodError = Class.new(NoMethodError)
  DateError = Class.new(ArgumentError)
end
