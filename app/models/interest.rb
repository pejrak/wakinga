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
  def post_content
    post_content_all - memorized_post_content(true) - memorized_post_content(false)
  end

  #this is all post content within the interest

  def post_content_all
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.rating',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?)", beads],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.rating',
        :order => 'created_at DESC')
  end

  def memorized_post_content(memorability)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.rating',
        :joins => [:beads_posts, :memorizations],
        :conditions => ["beads_posts.bead_id IN (?) AND memorizations.user_id = ? AND memorizations.memorable = ?", beads, user, memorability],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.rating',
        :order => 'created_at DESC')
  end

  def dynamic_post_content(time_at)
    Post.find(:all,
        :select => 'DISTINCT posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.rating',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?) AND posts.created_at > ?",beads, time_at],
        :having => ['count(distinct beads_posts.bead_id) = ?', beads.count],
        :group => 'posts.id, posts.title, posts.content, posts.created_at, posts.updated_at, posts.user_id, posts.rating',
        :order => 'created_at DESC') - memorized_post_content(true) - memorized_post_content(false)
  end

	def nearest_beads
		nearest_beads_ranks = BeadsPost.find(:all, :select => 'distinct beads_posts.bead_id, count(beads_posts.post_id) as post_count', :conditions => ['beads_posts.post_id IN (?)', post_content_all.map(&:id)], :order => 'post_count DESC', :group => :bead_id, :limit => 10)
		return Bead.where(:id => nearest_beads_ranks.map(&:bead_id)) - beads
	end

end
