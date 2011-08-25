class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :index
	before_filter :authenticate_admin!, :except => :show

  def show
    @user = User.find(params[:id])
  end

	def index
		@users = User.all
		@admins = Admin.all
	end

  def send_summary
    @user = User.find(params[:id])
    CustomUserMailer.send_summary(@user).deliver
    flash[:notice] = "sent daily summary to #{@user.email}"
    render '/home/admin'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Removed user."
    redirect_to users_url
  end

end
