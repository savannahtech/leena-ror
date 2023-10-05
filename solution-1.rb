class User < ApplicationRecord
  has_many :hits

  def count_hits
    # Cache the count of hits
    @count_hits ||= hits.where('created_at > ?', Time.now.beginning_of_month).count
  end
end

# Updated the method that returns the cache count to use memoization
