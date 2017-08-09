module Frgnt
  class Log
    include Singleton

    def initialize
      @logger = Logger.new(STDOUT)
    end

    def self.log(priority,*args)
      instance.log(priority,*args)
    end

    def log(priority,*args)
      [args].flatten.each do |msg|
        @logger.send('log',priority,msg)
      end
    end

    def self.logger(obj)
      instance.logger(obj)
    end

    def logger(obj)
      @logger = obj
    end
  end
end
