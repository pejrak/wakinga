class Interest < ActiveRecord::Base

  has_many :beads, :through => :beads_interests
  has_many :beads_interests, :dependent => :delete_all
  has_many :beads_posts, :through => :beads
  has_many :trusts
  belongs_to :user

  MAX_TITLE_LENGTH = 50
  #validations
  validates_length_of :title, :within => 2..MAX_TITLE_LENGTH


  #creating named url of /interests/id-name
  #  def to_param
  #    "#{id}-#{title}"
  #  end

  #extract all bead ids from beads in the interest
  def contain_ids
    container = []
    beads.each do |beader|
      container << beader.id
    end
  end

  def sorterize
    "..."
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


  def post_count_unread
    BeadsPost.find(:all, :select => ['DISTINCT post_id'], :joins => :post, :group => 'post_id', :conditions => ["bead_id IN (?) AND posts.created_at > ?", beads, last_visit_at], :having => ['count(distinct bead_id) = ?', beads.count]).count
  end

  #load all posts within beads of the current interest
  #refers to bead ids that were extracted in the bead_ids

  #this is content that shows in the middle area, that is not memorized or burned
  def post_content(selected_user)
    content = post_content_all(selected_user) - memorized_post_content(true,selected_user) - memorized_post_content(false,selected_user)
	return content.sort_by{|p| - p.created_at.to_i}
  end

  #this is all post content within the interest

  def trustors(selected_user)
    prot_trustors = []
    prot_trustors << selected_user
    all_trusts_for_selected_user = Trust.find_all_by_trustee_id(selected_user.id)
    all_trusts_for_selected_user.each do |t|
      if t.interest.beads.include?(self.beads) == true
        prot_trustors << t.interest.user
      end
    end
    return prot_trustors.uniq
  end

  def post_content_all(selected_user)
    #load trusts that are associated with interests containing the same beads combination as the current interest
    loaded_trustors = trustors(selected_user)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.p_private <> ?", beads, true],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC') +
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.p_private = ? AND posts.user_id IN (?)", beads, true, loaded_trustors],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC')
  end

  def memorized_post_content(memorability,selected_user)
    content = memorized_post_content_public(memorability,user) + memorized_post_content_private(memorability,selected_user)
	return content.sort_by{|p| - p.created_at.to_i}
  end

  def memorized_post_content_public(memorability,user)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => [:beads_posts, :memorizations],
        :conditions => ["beads_posts.bead_id IN (?) AND memorizations.user_id = ? AND memorizations.memorable = ? AND posts.p_private <> ?", beads, user, memorability, true],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC')
  end

  def memorized_post_content_private(memorability,selected_user)
    loaded_trustors = trustors(selected_user)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :joins => [:beads_posts, :memorizations],
        :conditions => ["beads_posts.bead_id IN (?) AND memorizations.user_id = ? AND memorizations.memorable = ? AND posts.p_private = ? AND posts.user_id IN (?)", beads, selected_user, memorability, true, loaded_trustors],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.p_private',
        :order => 'created_at DESC')
  end


  def dynamic_post_content(time_at, selected_user)
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
        :order => 'created_at DESC') - memorized_post_content(true,user) - memorized_post_content(false,user)
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

end
