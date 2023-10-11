class User < ApplicationRecord
  has_many :hits

  def count_hits
    # Cache the count of hits
    @count_hits ||= hits.where('created_at > ?', Time.now.beginning_of_month).count
  end
end

# Updated the method that returns the cache count to use memoization

# Here I am proposing #1 problem solution using Redis.
class User < ApplicationRecord
 has_many :hits, after_add: :increment_hits

 def count_hits
 $redis.get(hit_key) || get_set_hits
 end

 private

 def get_set_hits
 api_hits = hits.where('created_at > ?', Time.now.beginning_of_month).count
 $redis.set(hit_key, api_hits)
 api_hits
 end

 def increment_hits
 $redis.get(hit_key) ? $redis.incr(hit_key) : get_set_hits
 end

 def hit_key
 "hits_count_#{id}"
 end
end

# Suppose we are getting redis object inside global variable ($redis)
# We can call the increment hits method using a callback


