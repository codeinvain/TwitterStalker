class Cache
  
  CacheExperation= 5.days
  Stalkee = 'TwitterStalker:Stalkee'
  def initialize(redis)
    @redis = redis
  end
  
  def stalkee(name)
    if stalkee_exists(name)
      stalkee=  @redis.hgetall "#{Stalkee}:#{name}"
    else
      stalkee = {}
      stalkee[:cache_date]=Date.today
      stalkee[:profile_image] = Twitter.profile_image(name, :size => 'mini')
      stalkee[:followers] = Twitter.follower_ids(name).ids
      @redis.hmset "#{Stalkee}:#{name}" , *stalkee.to_a.flatten

    end 
    return stalkee
  end

  def stalkee_exists(name)
    if @redis.hexists Stalkee, name
      cache_date = @redis.hget "#{Stalkee}:#{name}", 'cache_date'
      if  (Date.today  - cache_date).to_i < CacheExperation
        return true
      end
    end
    return false
  end

end

