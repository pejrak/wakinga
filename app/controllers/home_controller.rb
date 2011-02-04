class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @interests = current_user.interests.limit(30)
  end

end
