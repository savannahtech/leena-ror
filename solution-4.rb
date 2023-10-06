# app/models/user.rb
class User < ApplicationRecord
  has_many :hits

  def current_month_hits
    # Cache the count of hits
    @current_month_hits ||= Time.use_zone(time_zone) do
			       hits.where('created_at > ?', Time.current.beginning_of_month).count
			     end
  end
end
# Use memoization to cache the instance variable
# Use Time.current instead of Time.now to prevent database mismatch
# Rename the count_hits method to current_month_hits to increase the readibility

# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  MAX_HIT_COUNT = 10_000

  before_filter :user_quota

  def user_quota
    render json: { error: 'over quota' } if current_user.current_month_hits >= MAX_HIT_COUNT
  end
end
# Use a constant to store the maximum number of hits
