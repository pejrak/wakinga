class Bead < ActiveRecord::Base
has_many :beads_interests
has_many :beads_posts, :dependent => :delete_all
has_many :interests, :through => :beads_interests
has_many :posts, :through => :beads_posts, :order => 'posts.updated_at DESC'
has_many :users, :through => :interests

  def post_count
    "#{beads_posts.count}"
  end

  def self.search(search)
    if search
      find(:all, :limit => 30, :conditions => ['title LIKE ? or description LIKE ?', "%#{search}%", "%#{search}%"], :order => 'title ASC')
    else
      find(:all, :limit => 10 )
    end
  end

end