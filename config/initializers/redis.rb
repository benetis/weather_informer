# config/initializers/redis.rb

require 'singleton'

class RedisConnection
  include Singleton

  def initialize
    @redis = Redis.new(url: 'redis://redis:6379/0')
  end

  def self.current
    instance.redis
  end

  attr_reader :redis
end
