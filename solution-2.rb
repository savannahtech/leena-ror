class User < ApplicationRecord
  has_many :hits

  def count_hits
    # Cache the count of hits
    @count_hits ||= hits.where('created_at > ?', Time.current.beginning_of_month).count
  end
end

# It might be related to the timezone issue as it might be using local time zones on different machines having different timezone so the counts are different even after new month is started in UTC.
