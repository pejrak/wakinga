class CommentsController < ApplicationController
before_filter :authenticate_user!
	def create
		
		@post = Post.find(params[:post_id])
		@comment = @post.comments.new(params[:comment])
    @comment.user = current_user
      if @comment.save
        respond_to do | format |
          format.js {render :layout => false}
        end
      end
	end
	def destroy 
		@post = Post.find(params[:post_id]) 
		@comment = @post.comments.find(params[:id]) 
		@comment.destroy redirect_to post_path(@post) 
	end 
end
