class Interest < ActiveRecord::Base

  has_many :beads, :through => :beads_interests
  has_many :beads_interests
  belongs_to :user

  def post_count
    BeadsPost.find(:all, :select => 'DISTINCT post_id', :conditions => {:bead_id => beads}).count
  end

  def post_content
#    beads_posts = BeadsPost.find(:all, :select => 'DISTINCT post_id', :conditions => {:bead_id => beads})
#    Post.find_by_id(beads_posts)

     Post.find(:all,
       :select => 'DISTINCT id, title, content, created_at, updated_at, user_id, rating',
       :joins => :beads_posts,
       :conditions => ["beads_posts.bead_id IN (?)",beads],
       :order => 'created_at DESC' )
  end
#    @postcontent = Post.find_by_sql ["SELECT DISTINCT ps.id, ps.title, content, ps.created_at, ps.updated_at, ps.user_id, ps.rating
#  FROM posts ps
#   INNER JOIN beads_posts bps ON bps.post_id = ps.id
#    INNER JOIN beads_interests bis ON bis.bead_id = bps.bead_id
#    WHERE bis.interest_id = ?
#    ORDER by ps.updated_at DESC", @interest.id]

end