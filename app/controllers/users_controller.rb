class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :receive_mail]
	before_filter :authenticate_admin!, :except => [:show, :mind_search, :receive_mail]

  def show
    @user = User.find(params[:id])
    @users_prefered_interests = @user.users_prefered_interests
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

  def receive_mail
    @params = params
    @inbound_mail = Request.new(:r_description => params["text"],
                      :r_title => params["from"],
                      :r_type => "email_inbound")
    respond_to do |format|
      if @inbound_mail.save && request.post?
        flash[:notice] = 'email recorded successfully'
        format.xml { render :xml => @inbound_mail, :status => :created }
      end
    end
  end

  def mind_search
    memory_array = current_user.good_memories.map(&:post_id)
    @search_results = Post.search(params[:mindsearch],memory_array)
    @previous_visit_record = current_user.last_sign_in_at
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    flash[:notice] = "Removed user."
    redirect_to users_url
  end

end
