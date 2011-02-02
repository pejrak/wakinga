class CommentsController < ApplicationController
before_filter :authenticate_user!
	def create
		
		@post = Post.find(params[:post_id])
		@comment = @post.comments.new(params[:comment])
		
		respond_to do |format|
		@comment.user = current_user
		if @comment.save
			flash[:notice] = 'Comment was successfully added.'
			format.html { redirect_to post_path(@post) }
			format.xml { render :xml => @comment, :status => :created, :location => @comment }
		else
			format.html { render :action => "new" }
			format.xml { render :xml => @comment.errors, :status => :unprocessable_entity }
			end
		end
	end
	def destroy 
		@post = Post.find(params[:post_id]) 
		@comment = @post.comments.find(params[:id]) 
		@comment.destroy redirect_to post_path(@post) 
	end 
end
