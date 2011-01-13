class PostsController < ApplicationController
before_filter :authenticate_user!, :except => [:show, :index]

  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.find(:all, :order => 'updated_at')


 #   respond_to do |format|
 #     format.html # index.html.erb
 #     format.xml { render :xml => @posts }
 #     format.json { render :json => @posts }
 #     format.atom
 #   end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create

	@post = Post.new(params[:post])
	@post.user = current_user
  @post.rating = 0

  respond_to do |format|
	if @post.save
        flash[:notice] = 'CREATED.'
        
        format.html { redirect_to :back, :params => @params }
        format.xml { render :xml => @post, :status => :created, :location => @post }
        
      else
        flash[:notice] = 'FAILED.'
        format.html { render :action => "new" }
        format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
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

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml { head :ok }
    end
  end
  
  def increase
   @post = Post.find(params[:id])
   @post.increment! :rating
   flash[:notice] = "Thanks for your rating."
   redirect_to :back, :params => @params

  end
  def decrease
   @post = Post.find(params[:id])
   @post.decrement! :rating
   flash[:notice] = "Thanks for your rating."
   redirect_to :back, :params => @params

  end
end