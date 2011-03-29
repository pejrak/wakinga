class PostsController < ApplicationController
before_filter :authenticate_user! #, :except => [:show, :index]

  def index
    @interest = Interest.find(params[:interest_id])
    @dynamic_posts = @interest.dynamic_post_content(Time.at(params[:after].to_i + 1))
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
        flash[:notice] = 'CREATED.'
        format.html {redirect_to @interest}
        format.js
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

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml { head :ok }
    end
  end
  
  def memorize
   @post = Post.find(params[:id])
   @post.increment! :rating
   flash[:notice] = "Thanks for your rating."
   redirect_to :back, :params => @params

  end
  def erase
   @post = Post.find(params[:id])
   @post.decrement! :rating
   flash[:notice] = "Thanks for your rating."
   redirect_to :back, :params => @params

  end
end