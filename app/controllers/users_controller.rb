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
    email = params["from"].match(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) {|m| m.to_s}
    to_email = params["to"].match(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) {|m| m.to_s}
    candidate_interest_id = to_email.to_s.match(/^(.*?)@/i) {|m| m.to_s}
    text = params["text"]
    @interest = Interest.find_by_id(candidate_interest_id)
    @user = User.find_by_email(email)
    if @interest && @user # && request.post?
        @duplicate_post = Post.find_all_by_content_and_user_id(text.truncate(320),@user.id)
      if  @duplicate_post.empty?
        @new_message = Post.new(:content => text.truncate(320),
                        :user_id => @user.id,
                        :p_private => true)
        @new_message.beads = @interest.beads

        respond_to do |format|
          if @new_message.save
            @memorization = Memorization.new(:post_id => @new_message.id, :memorable => true, :user_id => @user.id, :change_record => Memorization::MEMORY_AUTHORED, :status_indication => 'open')
            @memorization.save
            flash[:notice] = 'email recorded successfully'
            format.xml { render :xml => @new_message, :status => :created }
          end
        end
      else
        respond_to do |format|
        flash[:notice] = 'duplicate record detected'
            format.xml { render :xml => @params, :status => :unprocessable_entity }
        end
      end
    else 
      respond_to do |format|
        flash[:notice] = 'author or interest not found'
            format.xml { render :xml => @params, :status => :unprocessable_entity }
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
