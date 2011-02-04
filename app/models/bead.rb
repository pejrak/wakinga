class Bead < ActiveRecord::Base
has_many :beads_interests
has_many :beads_posts
has_many :interests, :through => :beads_interests
has_many :posts, :through => :beads_posts
has_many :users, :through => :interests

  def post_count
    "#{posts.count}"
  end

  def self.search(search)
    if search
      find(:all, :limit => 30, :conditions => ['title OR description LIKE ?', "%#{search}%"])
    else
      find(:all, :limit => 10 )
    end
  end

end