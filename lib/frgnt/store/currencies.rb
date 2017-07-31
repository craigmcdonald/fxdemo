module Frgnt
  module Store
    class Currencies
      class << self
        attr_reader :store

        def config(&block)
          instance_eval(&block)
        end

        def [](key)
          @store[key]
        end

        def []=(key,value)
          @store[key] = value
        end

        private

        def set_store(sym,secret="")
          case sym
          when :memory
            @store = {}
          when :redis
            @store = Redis::HashKey.new(secret,marshal: true)
          else
            raise StandardError.new("Invalid store type: #{sym}")
          end
        end
      end
    end
  end
end
