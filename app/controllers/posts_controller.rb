class PostsController < ApplicationController
before_filter :authenticate_user! #, :except => [:show, :index]

  def index
    @interest = Interest.find(params[:interest_id])
    if params[:full_refresh] == 'true'
      @dynamic_posts = []
    elsif params[:full_refresh] == 'false'
      (params[:after].nil?) ? time_at = 0 : time_at = params[:after].to_i + 1
      @dynamic_posts = @interest.dynamic_post_content(Time.at(time_at))
    end
  end

  def show
    @post = Post.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @post }
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
  end

  def create
    @post = Post.create!(params[:post])
    @post.user = current_user
    @interest = Interest.find(params[:beads_posts][:interest_id])
    @post.beads = @interest.beads
#    @dynamic_posts = @interest.dynamic_post_content(Time.at(params[:after].to_i + 1))
    respond_to do |format|
      if @post.save
        @memorization = Memorization.new
        @memorization.post_id = @post.id
        @memorization.memorable = true
        @memorization.user_id = current_user.id
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
     @memorization.memorable = true
     @memorization.user_id = current_user.id
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
     @memorization.post_id = @post.id
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

  def activate
    @post = Post.find(params[:id])
    if params.has_key?(:indicator) 
      @refresh_indicator = true
    else  @refresh_indicator = false
    end
    respond_to do | format |
      format.js
    end
  end

end