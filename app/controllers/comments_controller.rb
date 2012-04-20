class CommentsController < ApplicationController
before_filter :authenticate_user!
	def create
		
		@post = Post.find(params[:post_id])
    (current_user.comments.last)? comment_separator = current_user.comments.last.created_at.to_i : comment_separator = 0
    if (Time.now.to_i - comment_separator) > 5
      @comment = @post.comments.new(params[:comment])
      @comment.user = current_user
      if @comment.save
        respond_to do | format |
          flash[:notice] = "Comment added."
          format.js {render :layout => false}
        end
      end
    else
      flash[:notice] = "Cooling off."
    end
	end

  def show
    @comment = Comment.find(params[:id])
    flash[:notice] = 'View comments and messages through the interests.'
    redirect_to :back
  end
  
	def destroy 
		@comment = Comment.find(params[:id])
    @post = @comment.post
		@comment.update_attribute(:body, 'comment_deleted')
    flash[:notice] = 'Removed.'
    respond_to do |format|
      format.js {render :layout => false}
    end
    #redirect_to post_path(@post)
	end 
end
