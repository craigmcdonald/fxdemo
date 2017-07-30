module Frgnt
  module Store
    class << self
      extend Forwardable
      def_delegator :currencies, :config

      def currencies
        Currencies
      end
    end

    class Currencies
      class << self

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
