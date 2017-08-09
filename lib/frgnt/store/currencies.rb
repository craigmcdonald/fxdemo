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

        alias find []

        def []=(key,value)
          @store[key] = value
        end

        def list
          list = store.keys.map {|k| [k,store[k].name] }
          list.sort
        end

        def batch_upsert(response)
          Frgnt::Log.log(3,response.errors) if response.errors && response.errors.any?
          response.body.each do |row|
            row.currencies.each do |currency|
              upsert_currency(row.date,currency.iso_4217,currency.rate)
            end
          end
        end

        def upsert_currency(date,iso_4217,rate)
          Currencies[iso_4217] = Currency.find_or_initialize_by(iso_4217).add_rate(date,rate)
          Frgnt::Log.log(1,"updated #{iso_4217} on #{date}")
        end

        private

        def set_base(iso_4217)
          @store[iso_4217] = BaseCurrency.new(iso_4217)
        end

        def logger(obj)
          Frgnt::Log.logger(obj)
        end

        def reset_store(flag=true)
          @store.clear if flag
        end

        def set_store(sym,secret=nil)
          case sym
          when :memory
            @store = {}
          when :redis
            @store = Redis::HashKey.new(secret,marshal: true)
          else
            raise StoreTypeNotImplemented.new("Store type: #{sym.to_s} has not been implemented.")
          end
        end
      end
    end
  end
end
