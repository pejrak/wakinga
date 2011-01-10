class UsersController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    # If this show page is only for the currently logged in user change it to @user = current_user
    ratingcounter = 0
    @user.posts.each do |sum|
      ratingcounter += sum.rating
    end
    @userrating = ratingcounter
    @postids = []
    @user.posts.each do |print|
      @postids << print.id
    end
  end

end