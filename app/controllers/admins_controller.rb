class AdminsController < ApplicationController

  before_filter :authenticate_admin!

  def show
    @admin = Admin.find(params[:id])
  end

  def reset_counts
    @beads = Bead.all
    @beads.each do |bead|
      Bead.reset_counters(bead.id, :beads_posts)
    end
    render '/home/admin'
  end

  def remove_user_orphans
    Interest.where(:user_id => params[:user_id]).destroy
    Post.where(:user_id => params[:user_id]).destroy
    Trust.where(:user_id => params[:user_id]).destroy
    UserPreference.where(:user_id => params[:user_id]).destroy
    Memorization.where(:user_id => params[:user_id]).destroy
    Comment.where(:user_id => params[:user_id]).destroy
    Registration.where(:user_id => params[:user_id]).destroy
    Authentication.where(:user_id => params[:user_id]).destroy
    redirect_to 'home/admin'
  end


end
