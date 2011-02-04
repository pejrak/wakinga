class BeadsPostsController < ApplicationController
  def index
    @beads_posts = BeadsPost.all
  end

  def show
    @beads_post = BeadsPost.find(params[:id])
  end

  def new
    @beads_post = BeadsPost.new
  end

  def create
    @beads_post = BeadsPost.new(params[:beads_post])
    if @beads_post.save
      flash[:notice] = "Successfully created beads post."
      redirect_to @beads_post
    else
      render :action => 'new'
    end
  end

  def edit
    @beads_post = BeadsPost.find(params[:id])
  end

  def update
    @beads_post = BeadsPost.find(params[:id])
    if @beads_post.update_attributes(params[:beads_post])
      flash[:notice] = "Successfully updated beads post."
      redirect_to beads_post_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @beads_post = BeadsPost.find(params[:id])
    @beads_post.destroy
    flash[:notice] = "Successfully destroyed beads post."
    redirect_to beads_posts_url
  end
end
