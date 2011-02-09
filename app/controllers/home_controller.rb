class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @interests = current_user.interests.order('title ASC')
  end

end
