class Interest < ActiveRecord::Base

  #include Rhoconnect::Resource

  has_many :beads, :through => :beads_interests
  has_many :beads_interests, :dependent => :destroy
  has_many :trusts, :dependent => :destroy
  has_many :user_interest_preferences, :dependent => :destroy
  has_many :interests_posts, :dependent => :destroy
  has_many :posts, :through => :interests_posts

  MAX_TITLE_LENGTH = 250
  COMBINATION_SUGGESTION_SIZE = 10
  MAX_INITIAL_DISPLAYED_MESSAGES = 50
  MAX_MEMORY = 500
  EMAIL_ADDRESS_SUFFIX = '@mail.wakinga.com'

  #validations
  validates_length_of :title, :within => 2..MAX_TITLE_LENGTH

  def email_address
    return self.id.to_s + Interest::EMAIL_ADDRESS_SUFFIX
  end

  def parent_beads
    self.beads.where(:parent_bead => true)
  end
  #creating named url of /interests/id-name
  #  def to_param
  #    "#{id}-#{title}"
  #  end

  #find the user preference for the interest
  def preference_for(selected_user)
    user_interest_preferences.where(:user_id => selected_user.id).first
  end

  def title_with_beads
    title_concat = ""
    self.beads.each do |b|
      title_concat = title_concat + " ." + b.title
    end
    return title_concat + ""
  end

  def other_matching_interests
    self.compare_beads_with_other_interests(Interest.where('interests.id <> ? AND i_seal = true', self.id))
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
    self.interests_posts.count
  end

  def post_count_unread(selected_user)
    property_source = preference_for(selected_user)
    last_check_at = ((property_source.present?)? property_source.last_visit_at : selected_user.last_sign_in_at)
    self.interests_posts.find(:all, :conditions => ["interests_posts.created_at > ?", last_check_at]).size
  end


  #load all posts within beads of the current interest
  #refers to bead ids that were extracted in the bead_ids
  #this is content that shows in the middle area, that is not memorized or burned

  #returns all messages without user's memories
  def post_content(selected_user)
    return self.post_content_all_without_memories(selected_user)
  end

  #this function finds all trustors for the selected user

  def trustors(selected_user)
    other_trustors(selected_user) << selected_user.id
  end

  def other_trustors(selected_user)
    return self.trusts.where(:trustee_id => selected_user.id).map(&:trustor_id).uniq
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
    return Post.find(
      :all,
      :include => [:comments,:memorizations],
      :conditions => ['comments.updated_at > memorizations.updated_at AND memorizations.memorable = ? AND memorizations.user_id = ? AND posts.id IN (?)',
        true,
        selected_user.id,
        loaded_post_ids]
    )
  end
  #returns all messages (public, private and personal), used for counts only and as a superset
  def post_content_all(selected_user)
    #load trusts that are associated with interests containing the same beads combination as the current interest
    loaded_trustors = trustors(selected_user)
    
    public_posts = self.posts.find(:all,
        :conditions => ["posts.p_private = ?", 0],
        :order => 'posts.updated_at DESC')
    if loaded_trustors.present?
      private_posts = self.posts.find(:all,
        :conditions => ["posts.p_private = ? AND posts.user_id IN (?)", 1, loaded_trustors],
        :order => 'posts.updated_at DESC')
    else private_posts = []
    end
    
    return private_posts + public_posts
  end

  #all messages without memories of the selected user
  def post_content_all_without_memories(selected_user)
    loaded_trustors = trustors(selected_user)
    public_posts = self.posts.find(:all,
        #:include => :memorizations,
        :conditions => ["NOT EXISTS (SELECT * FROM memorizations WHERE memorizations.user_id = ? AND memorizations.post_id = posts.id) AND posts.p_private = ?",selected_user.id,0],
        :order => 'posts.created_at DESC')
    if loaded_trustors.present?
      private_posts = self.posts.find(:all,
        #:include => :memorizations,
        :conditions => ["NOT EXISTS (SELECT * FROM memorizations WHERE memorizations.user_id = ? AND memorizations.post_id = posts.id) AND posts.p_private = ? AND posts.user_id IN (?)",selected_user.id,1, loaded_trustors],
        :order => 'posts.created_at DESC')
    else private_posts = []
    end
    return private_posts + public_posts
  end

  def xxxpost_content_private(selected_user)
    personal_posts = self.posts.find(:all,
        :conditions => ["posts.p_private = ? AND posts.user_id = ?", 1, selected_user.id],
        :order => 'posts.updated_at DESC')
    return personal_posts
  end

  def post_content_private(selected_user)
    loaded_trustors = trustors(selected_user)
    if loaded_trustors.present?
      private_posts = self.posts.find(:all,
        :conditions => ["NOT EXISTS (SELECT * FROM memorizations WHERE memorizations.user_id = ? AND memorizations.post_id = posts.id) AND posts.p_private = ? AND posts.user_id IN (?)", selected_user.id, 1, loaded_trustors],
        :order => 'posts.updated_at DESC')
    else private_posts = []
    end
    return private_posts
  end


  def memorized_post_content(memorability,selected_user,unload='complete')
    content = memorized_post_content_public(memorability,selected_user,unload) + memorized_post_content_private(memorability,selected_user,unload) + memorized_post_content_personal(memorability,selected_user,unload)
	return content.sort_by{|p| - p.created_at.to_i}
  end

  def memorized_post_content_public(memorability,user,unload='complete')
    self.posts.find(:all,
        :include => :memorizations,
        :conditions => ["memorizations.user_id = ? AND memorizations.memorable = ? AND memorizations.status_indication NOT IN (?) AND posts.p_private = ?", user, memorability, unload, 0],
        :order => 'posts.updated_at DESC')
  end

  def memorized_post_content_private(memorability,selected_user,unload='complete')
    loaded_trustors = trustors(selected_user)
    self.posts.all(:include => :memorizations,
        :conditions => ["memorizations.user_id = ? AND memorizations.memorable = ? AND memorizations.status_indication NOT IN (?) AND posts.p_private = ? AND posts.user_id IN (?)", selected_user, memorability, unload, 1, loaded_trustors],
        :order => 'posts.updated_at DESC')
  end

  def memorized_post_content_personal(memorability,selected_user,unload='complete')
    self.posts.all(:include => :memorizations,
        :conditions => ["posts.user_id = ? AND memorizations.user_id = ? AND memorizations.memorable = ? AND memorizations.status_indication NOT IN (?) AND posts.p_private = ?",selected_user, selected_user, memorability, unload, 2],
        :order => 'posts.updated_at DESC')
  end


end
