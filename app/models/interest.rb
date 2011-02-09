class Interest < ActiveRecord::Base

  has_many :beads, :through => :beads_interests
  has_many :beads_interests
  belongs_to :user

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

  #load all posts within beads of the current interest
  #refers to bead ids that were extracted in the bead_ids
  
  
  def post_content
    Post.find(:all,
        :select => 'DISTINCT id, title, content, created_at, updated_at, user_id, rating',
        :joins => :beads_posts,
        :conditions => ["beads_posts.bead_id IN (?)",beads], :having => ['count(distinct bead_id) = ?', beads.count],
        :group => :id,
        :order => 'created_at DESC' )
  end
end