class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:admin]
  before_filter :authenticate_admin!, :except => [:index, :load_with_ajax]
  def index
    current_user.interests.each { |i| (i.beads == nil)? i.destroy : i}    
    @interests = current_user.interests.order('interests.title ASC')
  end

  def admin
    render :layout => 'administrative'
  end

  def load_with_ajax
    @load_type = params[:load_type].to_s
    if @load_type == 'active_beads'
      @loaded_content = Bead.joins(:posts).order("posts.created_at DESC").limit(10).uniq
    elsif @load_type == 'recent_beads'
      @loaded_content = Bead.order("created_at DESC").limit(10)
    elsif @load_type == 'top_beads_overall'
      @loaded_content = Bead.find(:all,
      :select => 'id, title, description, count(distinct beads_posts.post_id) AS post_counter',
      :joins => :beads_posts,
      :group => ['id','title','description'],
      :order => 'post_counter DESC',
      :limit => 10
    )
    end
    respond_to do | format |
      format.js
    end
  end

end
