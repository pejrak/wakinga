class Interest < ActiveRecord::Base

  has_many :beads, :through => :beads_interests
  has_many :beads_interests, :dependent => :destroy
  has_many :beads_posts, :through => :beads
  has_many :trusts, :dependent => :destroy
  has_many :user_interest_preferences, :dependent => :destroy
  ##belongs_to :user

  MAX_TITLE_LENGTH = 50
  COMBINATION_SUGGESTION_SIZE = 10
  MAX_INITIAL_DISPLAYED_MESSAGES = 50
  MAX_MEMORY = 500

  #validations
  validates_length_of :title, :within => 2..MAX_TITLE_LENGTH



  #creating named url of /interests/id-name
  #  def to_param
  #    "#{id}-#{title}"
  #  end

  #find the user preference for the interest
  def preference_for(selected_user)
    user_interest_preferences.where(:user_id => selected_user.id).first
  end

  def title_with_beads
    title_concat = " ("
    self.beads.each do |b|
      title_concat = title_concat + "/" + b.title
    end
    return title_concat + ")"
  end

  def other_matching_interests
    self.compare_beads_with_other_interests(Interest.where('interests.id <> ?', self.id))
  end

  #function to compare the beads contained in other interests(that are passed as an argument) and returns all of the selected interests containing the same beads
  #this function is reused across trust building as well as displaying preview of interests
  def compare_beads_with_other_interests(interests)
    matching_interests = []
    b2 = beads.map(&:id).sort
    interests.each do |i|
      b1 = i.beads.map(&:id).sort
      if b1 == b2
        matching_interests << i
      end
    end
    return matching_interests
  end

  #function to find users with the same adopted interest

  def users_sharing_the_same_interest
    self.user_interest_preferences.map(&:user_id)
  end

  #return number of all posts within the interest,
  #refers to bead ids that were extracted in the bead_ids
  def post_count
    BeadsPost.find(:all, :select => ['DISTINCT post_id'], :group => 'post_id', :conditions => ["bead_id IN (?)", beads], :having => ['count(distinct bead_id) = ?', beads.count]).count
  end

  def estimated_post_count(additional_bead)
    considered_beads = Bead.where(:id => additional_bead) + beads
    BeadsPost.find(:all, :select => ['DISTINCT post_id'], :group => 'post_id', :conditions => ["bead_id IN (?)", considered_beads], :having => ['count(distinct bead_id) = ?', beads.count + 1]).count
  end

  def post_count_unread(selected_user)
    property_source = preference_for(selected_user)
    last_visit_at = ((property_source.present?)? property_source.last_visit_at : selected_user.last_sign_in_at)
    BeadsPost.find(:all, :select => ['DISTINCT post_id'], :joins => :post, :group => 'post_id', :conditions => ["bead_id IN (?) AND posts.created_at > ?", beads, last_visit_at], :having => ['count(distinct bead_id) = ?', beads.count]).count
  end


  #load all posts within beads of the current interest
  #refers to bead ids that were extracted in the bead_ids
  #this is content that shows in the middle area, that is not memorized or burned
  def post_content(selected_user)
    content = post_content_all(selected_user) - memorized_post_content(true,selected_user,'other') - memorized_post_content(false,selected_user,'other')
	return content.sort_by{|p| - p.created_at.to_i}
  end

  #this function finds all trustors for the selected user

  def trustors(selected_user)
    return self.trusts.where(:trustee_id => selected_user.id).map(&:trustor_id).uniq << selected_user.id
  end

  def trustees(selected_user)
    return self.trusts.where(:trustor_id => selected_user.id).map(&:trustee_id).uniq
  end

  def trusts_from(selected_trustor)
    self.trusts.where(:trustor_id => selected_trustor.id)
  end

  #find all offered trusts for the current interest

  def trusts_to(selected_trustee)
    self.trusts.where(:trustee_id => selected_trustee.id)
  end

  def unconfirmed_trusts_from(selected_user)
    users_trustors = trustors(selected_user) - [selected_user.id]
    users_trustees = trustees(selected_user)
    unbound_trustees = users_trustees - users_trustors
    return trusts.where(:trustor_id => selected_user, :trustee_id => unbound_trustees)
  end

  def unconfirmed_trusts_to(selected_user)
    users_trustors = trustors(selected_user) - [selected_user.id]
    users_trustees = trustees(selected_user)
    unbound_trustors = users_trustors - users_trustees
    return trusts.where(:trustor_id => unbound_trustors, :trustee_id => selected_user)
  end

  def live_message_content(selected_user)
    loaded_post_ids = memorized_post_content(true,selected_user).map(&:id)
    return Post.find(:all, :include => [:comments,:memorizations], :conditions => ['comments.updated_at > memorizations.updated_at AND memorizations.memorable = ? AND memorizations.user_id = ? AND posts.id IN (?)', true, selected_user.id, loaded_post_ids])
  end

  def post_content_all(selected_user)
    #load trusts that are associated with interests containing the same beads combination as the current interest
    loaded_trustors = trustors(selected_user)
    
    public_posts = Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.p_private <> ?", beads, true],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'posts.updated_at DESC')
    if loaded_trustors.present?
      private_posts = Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.p_private = ? AND posts.user_id IN (?)", beads, true, loaded_trustors],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'posts.updated_at DESC')
    else private_posts = []
    end
    return private_posts + public_posts

  end

  def memorized_post_content(memorability,selected_user,unload='complete')
    content = memorized_post_content_public(memorability,selected_user,unload) + memorized_post_content_private(memorability,selected_user,unload)
	return content.sort_by{|p| - p.created_at.to_i}
  end

  def memorized_post_content_public(memorability,user,unload='complete')
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => [:beads_posts, :memorizations],
        :conditions => ["beads_posts.bead_id IN (?) AND memorizations.user_id = ? AND memorizations.memorable = ? AND memorizations.status_indication NOT IN (?) AND posts.p_private <> ?", beads, user, memorability, unload, true],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'posts.updated_at DESC')
  end

  def memorized_post_content_private(memorability,selected_user,unload='complete')
    loaded_trustors = trustors(selected_user)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => [:beads_posts, :memorizations],
        :conditions => ["beads_posts.bead_id IN (?) AND memorizations.user_id = ? AND memorizations.memorable = ? AND memorizations.status_indication NOT IN (?) AND posts.p_private = ? AND posts.user_id IN (?)", beads, selected_user, memorability, unload, true, loaded_trustors],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'posts.updated_at DESC')
  end


  def dynamic_post_content(time_at, selected_user,unload='complete')
    loaded_trustors = trustors(selected_user)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.created_at > ? AND posts.p_private <> ?",beads, time_at, true],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC') +
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.created_at > ? AND posts.p_private = ? AND posts.user_id IN (?)",beads, time_at, true, loaded_trustors],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC') - memorized_post_content(true,selected_user,'other') - memorized_post_content(false,selected_user,'other')
  end

  def conditional_post_content(user,beads,time_at,memorability)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => [:beads_posts, :memorizations],
        :conditions => ["beads_posts.bead_id IN (?) AND memorizations.user_id = ? AND memorizations.memorable = ? AND posts.created_at > ?", beads, user, memorability, time_at],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC')
  end

  def nearest_beads
    nearest_beads_ranks = BeadsPost.find(:all, :select => 'distinct beads_posts.bead_id, count(beads_posts.post_id) as post_count', :conditions => ['beads_posts.post_id IN (?)', post_content_all(user).map(&:id)], :order => 'post_count DESC', :group => :bead_id, :limit => 10)
    return Bead.where(:id => nearest_beads_ranks.map(&:bead_id)) - beads
  end
    

  def nearest_beads_combination(c_size)
    if beads.size > 0
      available_beads = Bead.all.map(&:id) - beads.map(&:id)
      combinations_of_available_beads = available_beads.combination(c_size-beads.size).to_a
      combinations_with_rankings = combinations_of_available_beads.each {|c| c.insert(0,BeadsPost.find(:all, :select => ['DISTINCT post_id'], :group => 'post_id', :conditions => ["bead_id IN (?)", c + beads.map(&:id)], :having => ['count(distinct bead_id) = ?', c_size]).count)}
      sorted_combinations = combinations_with_rankings.sort_by {|c| -c.first}
      top_sorted_combinations = sorted_combinations.shift(COMBINATION_SUGGESTION_SIZE)
      return top_sorted_combinations
    else return nil
    end   
  end

end
