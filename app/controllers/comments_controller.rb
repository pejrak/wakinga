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
	def destroy 
		@post = Post.find(params[:post_id]) 
		@comment = @post.comments.find(params[:id]) 
		@comment.destroy redirect_to post_path(@post) 
	end 
end
