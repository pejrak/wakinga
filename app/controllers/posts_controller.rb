  class PostsController < ApplicationController
before_filter :authenticate_user! #, :except => [:show, :index]

  def index
    @interest = Interest.find(params[:iid])
    @previous_visit_record = Time.at(params[:pvr].to_i)
    @initial_load = params[:il].to_i
    @load_type = params[:lt]
    @raw_message_content = @interest.post_content(current_user)
    @raw_memory_content = @interest.memorized_post_content(true,current_user,'other')
    @most_recent_message = @raw_message_content.first
    puts "preloaded interest - #{@interest.id}, last visited #{@previous_visit_record}"
    if @interest && params[:lt] == 'streammessages'
      @message_content_private = @interest.post_content_private(current_user)
      @message_content_all = @raw_message_content
      if params[:ft] == 'filterall'
        @message_content = @message_content_all.sort_by { |p| -p.display_time_at }.paginate(:per_page=> current_user.user_preference.messages_per_page, :page => params[:page])
      elsif params[:ft] == 'filterprivate'
        @message_content = @message_content_private.sort_by { |p| -p.display_time_at }.paginate(:per_page=> current_user.user_preference.messages_per_page, :page => params[:page])
      end
      @message_content_type = 'messages'
      puts "preloaded messages"
    elsif @interest && params[:lt] == 'streammemories'
      archive_filter = ['open','action']
      active_filter = ['archive','complete']
      @archive_memories = @interest.memorized_post_content(true,current_user,archive_filter)
      @active_memories = @interest.memorized_post_content(true,current_user,active_filter)
      if params[:ft] == 'filteractive'
        @message_content = @active_memories.sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
      elsif params[:ft] == 'filterarchive'
        @message_content = @archive_memories.sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
      end
      @message_content_type = 'memories'
      puts "preloaded memories"
    end
  end

  def dynamic_load
    @interest = Interest.find(params[:iid])
    @previous_visit_record = Time.now
#the same as under index
    @raw_message_content = @interest.post_content(current_user)

    if @interest && params[:lt] == 'streammessages'
      #@message_content_size = @raw_message_content.size
      @message_content_all = @raw_message_content.sort_by { |p| -p.display_time_at }.paginate(:per_page=> current_user.user_preference.messages_per_page, :page => params[:page])
      if params[:ft] == 'filterall'
        @message_content = @message_content_all
      elsif params[:ft] == 'filterprivate'
        @message_content_private = @interest.post_content_private(current_user).sort_by { |p| -p.display_time_at }.paginate(:per_page=> current_user.user_preference.messages_per_page, :page => params[:page])
        @message_content = @message_content_private
      end
      @message_content_type = 'messages'
      puts "preloaded messages"
    elsif @interest && params[:lt] == 'streammemories'
      @raw_memory_content = @interest.memorized_post_content(true,current_user,'other')
      archive_filter = ['open','action']
      active_filter = ['archive','complete']
      @archive_memories = @interest.memorized_post_content(true,current_user,archive_filter).sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
      @active_memories = @interest.memorized_post_content(true,current_user,active_filter).sort_by { |p| -p.memory_updated_at(current_user) }.paginate(:per_page => current_user.user_preference.messages_per_page, :page => params[:page])
      if params[:ft] == 'filteractive'
        @message_content = @active_memories
      elsif params[:ft] == 'filterarchive'
        @message_content = @archive_memories
      end
      @message_content_type = 'memories'
      puts "preloaded memories"
    end

    #end of same
    if request.xhr?
      render :partial => 'post', :collection => @message_content
    end
    puts "reloaded dynamic post content"
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
    unless params[:interest_id]
      @interest = current_user.users_prefered_interests_all.first
    else
      @interest = Interest.find(params[:interest_id])
    end
    respond_to do |format|
      format.js
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
    if params[:post][:interest_id]
      @interest = Interest.find(params[:post][:interest_id])
      @post = Post.new(
        :content => params[:post][:content],
        :p_private => params[:post][:p_private]
        )
    else
      @interest = Interest.find(params[:beads_posts][:interest_id])
      @post = Post.new(params[:post])
    end
    @post.user = current_user
    @post.interests << @interest
    respond_to do |format|
      if @post.save
        @memorization = Memorization.new(:post_id => @post.id, :memorable => true, :user_id => current_user.id, :change_record => Time.now.to_s + Memorization::MEMORY_AUTHORED, :status_indication => 'action')
        @memorization.save
        flash[:notice] = "Message sent to interest."#<a href=\"/interests/#{@interest.id}\">#{@interest.title_with_beads}</a>"
        format.html {redirect_to @interest}
        format.js {render :layout => false}
    #if there are minds selected to share the memory

    if params[:selected_minds]
      array_of_minds = params[:selected_minds]
      array_of_minds.each do |mind|
        if @interest.trustors(current_user).include?(mind.to_i)
          Memorization.create(:post_id => @post.id, :user_id => mind.to_i, :memorable => true, :change_record =>  Time.now.to_s + Memorization::MEMORY_GIVEN, :status_indication => 'action')
        end
      end
    end


      else
        flash[:notice] = 'Unable to submit the message.'
        @failure = true
        format.js {render :layout => false}
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
     @memorization.status_indication = "action"
     @memorization.memorable = true
     @memorization.user_id = current_user.id
     @memorization.change_record = Time.now.to_s + Memorization::MEMORY_START
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
     @memorization.change_record = Time.now.to_s + Memorization::MEMORY_BURN
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

  #mobile app specific actions
  def load_per_user_interest
    users_interests = current_user.users_prefered_interests_all
    @posts = []
    users_interests.each do |i|
      interload = i.post_content_all(current_user)
      if interload != nil
        interload.each {|p|
          p['interest_id'] = i.id
          p['username'] = p.user.username
          @posts << p
        }
      end
    end
    respond_to do |format|
      format.json {render :json => @posts}
    end
  end
end
