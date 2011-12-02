class Bead < ActiveRecord::Base
has_many :beads_interests
has_many :beads_posts, :dependent => :destroy
has_many :interests, :through => :beads_interests
has_many :posts, :through => :beads_posts, :order => 'posts.updated_at DESC'
has_many :users, :through => :interests

  MAX_TITLE_LENGTH = 30
  #validations
  validates_uniqueness_of :title, :case_sensitive => false
  validates_length_of :title, :within => 2..MAX_TITLE_LENGTH

  def post_count
    "#{beads_posts.count}"
  end

  #creating named url of /beads/id-name
#  def to_param
#    "#{id}-#{title}"
#  end

  def self.search(search)
    if search
      find(:all, :limit => 30, :conditions => ['UPPER(beads.title) LIKE UPPER(?) OR UPPER(beads.description) LIKE UPPER(?)', "%#{search}%", "%#{search}%"], :order => 'beads_posts_count DESC')
    else
      find(:all, :limit => 10, :order => 'beads_posts_count DESC' )
    end
  end

  #returns array of interest ids having the selected bead
  def all_interests_with_this_bead
    return BeadsInterest.find(:all, :joins => [:bead, :interest], :conditions => ['beads.id = ? AND interests.i_seal = true', self.id]).map(&:interest_id).uniq
  end

  def post_ids
    posts.find(:all, :select => 'distinct posts.id as post_id')
  end

  def nearest_beads_ranks
    BeadsPost.find(:all, :select => 'distinct beads_posts.bead_id, count(beads_posts.post_id) as post_count', :conditions => ['beads_posts.post_id IN (?) and beads_posts.bead_id <> ?', posts.map(&:id), self], :order => 'post_count DESC', :group => :bead_id, :limit => 7)
  end

  def nearest_match
    #near_posts_ids = posts.find(:all, :select => 'distinct posts.id as post_id')
    Bead.where(:id => nearest_beads_ranks.map(&:bead_id))
  end


end
