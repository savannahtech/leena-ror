
# Here I am proposing 2 solutions to fix time zone issue to solve over quota and successful api request over monthly limit.

# Here we are supposing we are having time zone field we can use block to do calculations based on the user time zone. If we want to avoid that, we can use the around_filter as well on the controller level

# We can use any of the solution to resolve issues

# =============================================================
# Solution => 1
# =============================================================
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

# =============================================================
# Solution => 2
# =============================================================
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  MAX_HIT_COUNT = 10_000

  before_filter :user_quota
  around_filter :set_time_zone

  def user_quota
    render json: { error: 'over quota' } if current_user.current_month_hits >= MAX_HIT_COUNT
  end
  
  private
  
  def set_time_zone(&block)
    time_zone = current_user&.time_zone || 'UTC'
    Time.use_zone(time_zone, &block)
  end
end

