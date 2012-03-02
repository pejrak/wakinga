  class PostsController < ApplicationController
before_filter :authenticate_user! #, :except => [:show, :index]

  def index
    @interest = Interest.find(params[:iid])
    @previous_visit_record = Time.at(params[:pvr].to_i)
    @initial_load = params[:il].to_i
    @load_type = params[:lt]
    if params[:full_refresh] != 'false'
      @dynamic_posts = []
    elsif params[:full_refresh] == 'false'
      (params[:after].nil?) ? time_at = 0 : time_at = params[:after].to_i + 3
      @dynamic_posts = @interest.dynamic_post_content(Time.at(time_at),current_user)
    end
    if @interest && params[:lt] == 'openmessages' 
      show_options = ['archive','complete']
      @memorized_content = @interest.memorized_post_content(true,current_user,show_options).sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
      @raw_message_content = @interest.post_content(current_user)
      @most_recent_message = @raw_message_content.first
      @message_content = @raw_message_content.sort_by { |p| -p.display_time_at }.paginate(:per_page=> current_user.user_preference.messages_per_page, :page => params[:page])
    elsif @interest && params[:lt] == 'archivedmessages'
      @memorized_content = []
      show_options = ['action','']
      @message_content = @interest.memorized_post_content(true,current_user, show_options).sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
    end
  end

  def dynamic_load
    @interest = Interest.find(params[:iid])
    @previous_visit_record = Time.now
#the same as under index
    if @interest && params[:lt] == 'openmessages' 
      show_options = ['archive','complete']
      @memorized_content = @interest.memorized_post_content(true,current_user,show_options).sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
      @message_content = @interest.post_content(current_user).sort_by { |p| -p.display_time_at }.paginate(:per_page=> current_user.user_preference.messages_per_page, :page => params[:page])
    elsif @interest && params[:lt] == 'archivedmessages'
      @memorized_content = []
      show_options = ['action','']
      @message_content = @interest.memorized_post_content(true,current_user, show_options).sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
    end
    if request.xhr?
      render :partial => 'post', :collection => @message_content
    end
  end

  def show
    @post = Post.find(params[:id])

    if current_user == @post.user
      respond_to do |format|
        format.html # show.html.erb
        format.xml { render :xml => @post }
      end
    else flash[:notice] = 'View posts through the interests.'
      redirect_to :back
    end
  end
  def new
    @interest = Interest.find(params[:id])
    @post = Post.new(:bead_ids => @interest.beads.all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
        redirect_to @post
        flash[:notice] = 'Not your post.'
    end
  end

  def create
    @post = Post.create!(params[:post])
    @post.user = current_user
    @interest = Interest.find(params[:beads_posts][:interest_id])
    @post.beads = @interest.beads
    respond_to do |format|
      if @post.save
        @memorization = Memorization.new(:post_id => @post.id, :memorable => true, :user_id => current_user.id, :change_record => Memorization::MEMORY_AUTHORED, :status_indication => 'open')
        @memorization.save
        flash[:notice] = 'CREATED.'
        format.html {redirect_to @interest}
        format.js {render :layout => false}
      else
        flash[:notice] = 'FAILED.'
        render :action => 'new'
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user != current_user
        redirect_to @post
        flash[:notice] = 'This is not your post.'
    end
    @post.destroy
    flash[:notice] = 'Removed.'
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
  
  def memorize
   @post = Post.find(params[:id])
   @post.increment! :rating
   if Memorization.where(:post_id => @post, :user_id => current_user).empty?
     @memorization = Memorization.new
     @memorization.post_id = @post.id
     @memorization.status_indication = "open"
     @memorization.memorable = true
     @memorization.user_id = current_user.id
     @memorization.change_record = Memorization::MEMORY_START
     respond_to do | format |
       if @memorization.save
         flash[:notice] = 'Memorized.'
          format.js {render :layout => false}
       end
     end
   end
  end

  
  def forget
    @post = Post.find(params[:id])
    @memorization = Memorization.find_by_user_id_and_post_id(current_user, @post)
      if @memorization.present?
        @memorization.destroy
        flash[:notice] = 'Forgotten.'
        respond_to do | format |
         format.js {render :layout => false}
      end
    end
  end

  def burn
   @post = Post.find(params[:id])
   @post.decrement! :rating
   if Memorization.where(:post_id => @post, :user_id => current_user).empty?
     @memorization = Memorization.new
     @memorization.change_record = Memorization::MEMORY_BURN
     @memorization.post_id = @post.id
     @memorization.status_indication = 'burn'
     @memorization.memorable = false
     @memorization.user_id = current_user.id
     respond_to do | format |
       if @memorization.save
         flash[:notice] = 'Burned.'
          format.js {render :layout => false}
       end
     end
   end
  end

#activate action enables you to view the post details with javascript
  def activate
    @post = Post.find(params[:id])
    if params.has_key?(:indicator) 
      @refresh_indicator = true
    else @refresh_indicator = false
    end
    loaded_memorization = @post.memorizations.where(:user_id => current_user, :memorable => true).first
    if loaded_memorization && @refresh_indicator == false
      loaded_memorization.update_attributes(:updated_at => Time.now)
    end
    respond_to do | format |
      format.js
    end
  end

  def switch_privacy
    @post = Post.find(params[:id])
    (@post.p_private == false)? @post.p_private = true : @post.p_private = false
    if @post.save
      flash[:notice] = "Switched privacy to #{@post.p_private}."
      respond_to do | format |
        format.js
      end
    else
      flash[:notice] = 'Unable to switch.'
      redirect_to root_path
    end
  end

end
