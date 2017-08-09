module Frgnt
  module Store
    class BaseCurrency < Currency

      def initialize(iso_4217)
        super
        @rates = Hash.new(1.0)
      end

      def add_rate(*args)
        raise Frgnt::NoMethodError.new(error_msg(args))
      end

      private

      def error_msg(args)
        <<~MSG
          BaseCurrency#add_rate is disabled as objects of this class will always
          return a rate of 1.0. You attempted to call #add_rate with args:
          #{args.join(', ')}.
        MSG
      end
    end
  end
end
