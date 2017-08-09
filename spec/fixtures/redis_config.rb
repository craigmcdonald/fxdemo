require 'redis-objects'
require 'redis-namespace'

dir_path = '../'
file_name = 'redis.yml'
file_path = File.expand_path("#{dir_path}#{file_name}",__FILE__)
REDIS_CONFIG = YAML.load( File.open(file_path)).transform_keys_to_symbols
default = REDIS_CONFIG[:default]
config = default.merge(REDIS_CONFIG[:test])
$redis = Redis.new(config)
$redis_ns = Redis::Namespace.new(config[:namespace], :redis => $redis) if config[:namespace]
Redis::Objects.redis = $redis_ns
