module Cache
  def self.fetch(key, &block)
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
    Redis.current.expire(key, 60)
  end
end
