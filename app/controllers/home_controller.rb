class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:admin]
  before_filter :authenticate_admin!, :except => [:index, :load_with_ajax, :bead_point_load]
  def index
    #serves to clean up empty interests
    Interest.all.each { |i| (i.beads == [])? i.destroy : i}    
    @parent_beads_array = Bead.find_all_by_parent_bead(true)
    #i sort the array of returned beads by the number of interests they contain
    @parent_beads_array = @parent_beads_array.sort_by {|bead| -bead.all_interests_with_this_bead.size}
  end

  def bead_point_load
    @bead = Bead.find(params[:bead_id])
    initializer = params[:initialize].to_s
    #now I load the beads that are associated to the selected bead in the user's interests
    @users_interests_containing_selected_bead_array = BeadsInterest.find(:all, :joins => [:bead, :interest], :conditions => ['beads.id = ?', @bead.id]).map(&:interest_id)
    @users_interests_containing_selected_bead_array = @users_interests_containing_selected_bead_array.sort_by { |i| -Interest.find(i).memorized_post_content(true,current_user).size }
    respond_to do | format |
      format.js
    end
  end

  def load_with_ajax
    @load_type = params[:load_type].to_s
    if @load_type == 'active_beads'
      @loaded_content = Bead.joins(:posts).order("posts.created_at DESC").limit(10).uniq
    elsif @load_type == 'recent_beads'
      @loaded_content = Bead.order("created_at DESC").limit(10)
    elsif @load_type == 'top_beads_overall'
      @loaded_content = Bead.find(:all,
      :select => 'beads.id, title, description, count(distinct beads_posts.post_id) AS post_counter',
      :joins => :beads_posts,
      :group => ['beads.id','title','description'],
      :order => 'post_counter DESC',
      :limit => 10)
    end
    respond_to do | format |
      format.js
    end
  end

end
