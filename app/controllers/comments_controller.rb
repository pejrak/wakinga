class CommentsController < ApplicationController
before_filter :authenticate_user!
	def create
		if params[:post_id]
      @post = Post.find(params[:post_id])
    else
      @post = Post.find(params[:comment][:post_id])
    end
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

  def load_comments_per_memories
    users_interests = current_user.users_prefered_interests_all
    @comments = []
    users_interests.each do |i|
      interload = i.post_content_all(current_user)
      if interload != nil
        interload.each {|p|
          p.comments.each do |c|
            c['username'] = c.user.username
            @comments << c
          end
        }
        
      end
    end
    respond_to do |format|
      format.json {render :json => @comments}
    end
  end
end
