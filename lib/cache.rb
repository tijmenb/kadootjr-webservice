module Cache
  CACHE_INTERVAL = 60 # seconds

  def self.fetch(composed_key, &block)
    key = ["cache", composed_key].flatten.join(':')
    data = get(key)

    if !data
      data = yield
      set(key, data)
    end

    data
  end

  def self.get(key)
    data = Redis.current.get(key)
    JSON.parse(data) if data
  end

  def self.set(key, data)
    Redis.current.set(key, JSON.dump(data))
    Redis.current.expire(key, CACHE_INTERVAL)
  end

  def self.clear
    Redis.current.keys("cache:*").each do |key|
      puts "Removing #{key}"
      Redis.current.del(key)
    end
  end
end
