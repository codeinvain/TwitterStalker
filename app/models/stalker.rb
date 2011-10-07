class Stalker
  CacheExperation= 20 * 24 * 60 * 60 # 20 days in seconds
  Namespace = 'ts' 
  Stalkee = "#{Namespace}:stalkee" 
  StalkeeSet = "#{Namespace}:stalkees" 
  Follower = "#{Namespace}:follower"
  FollowerSet = "#{Namespace}:followers"
  StalkeeDiff ="#{Namespace}:diff"

  DemoSearches = ['danielissimo:rauchy',	'arikfr:liorsion:unativ',	'aviavital:danielissimo','avish:liorz',	'aloncarmel:erezcarmel:grimland:yaronta',	'chekofif:roniyaniv']

  def initialize(stalkees)
    @stalkees = stalkees
  end

  def search
    $redis.zincrby "#{Namespace}:search" ,1 ,@stalkees.join(':')
    results = {}
    results['stalkees'] = []
    @stalkees.each do |name|
      subject = stalkee(name)
      if !subject.nil?
        results['stalkees'] << {'name'=>name,'profile_image'=>subject['profile_image']}
      end
    end
    diff_set =  "#{StalkeeDiff}:#{@stalkees.join('_')}"
    follower_ids =  $redis.sinterstore diff_set ,*@stalkees.collect{|s_name| "#{Stalkee}:#{s_name}:followers" }
    non_existent = $redis.sdiff diff_set, FollowerSet
    top_non_existent = non_existent.first(100)
    all_followers = $redis.sinter diff_set
    all_followers  = all_followers & top_non_existent unless top_non_existent.empty?

    $redis.del diff_set
    cache_non_existent(top_non_existent) unless top_non_existent.empty?
    results['followers'] = []
    all_followers.each do |id| 
      results['followers'] <<  follower(id)
    end
    return results
  end 

  def cache_non_existent(non_existent)
    users = Twitter.users(non_existent.collect{|id|id.to_i});
    users.each do |user|
      follower = {}
      follower['profile_image'] = user.profile_image_url
      follower['name'] = user.name
      follower['screen_name'] = user.screen_name
      $redis.hmset "#{Follower}:#{user.id}:info" , *follower.to_a.flatten(1)
      $redis.sadd FollowerSet ,user.id
    end
  end
 
  def follower(user_id)
    if follower_exists?(user_id)
      follower =  $redis.hgetall "#{Follower}:#{user_id}:info"
    end
    return follower
  end 

  def follower_exists?(user_id)
    exists = $redis.exists "#{Follower}:#{user_id}:info"
    if (!exists)
      $redis.srem FollowerSet,user_id
    end
    return exists 
  end

  def stalkee(name)
    if stalkee_exists?(name)
      stalkee=  $redis.hgetall "#{Stalkee}:#{name}:info"
    else
      stalkee = {}
      begin
        stalkee['profile_image'] = Twitter.profile_image(name)
        $redis.hmset "#{Stalkee}:#{name}:info" , *stalkee.to_a.flatten(1)
        $redis.expire "#{Stalkee}:#{name}:info" , CacheExperation
        stalkee['followers'] = Twitter.follower_ids(name).ids
        $redis.sadd  "#{Stalkee}:#{name}:followers" , *stalkee['followers']
        $redis.expire "#{Stalkee}:#{name}:followers" , CacheExperation
      rescue
        stalkee = nil
      end
    end 
    return stalkee
  end

  def stalkee_exists?(name)
    return $redis.exists "#{Stalkee}:#{name}:info"
  end

  def self.top_searches
    stored_top_searches = $redis.zrevrangebyscore("#{Namespace}:search" ,'+inf' ,0 ,{:limit=> [0, 100 ]} )  
    removed_demo_searches = stored_top_searches - DemoSearches
    removed_single_searches = removed_demo_searches.reject{|s| !s.include?(':')}
  end


end
