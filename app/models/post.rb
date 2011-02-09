class Post < ActiveRecord::Base
validates :title, :presence => true, :length => { :minimum => 2, :maximum => 50 }
validates :content, :presence => true, :length => { :minimum => 1, :maximum => 320 }

  #associations
has_many :comments, :dependent => :destroy
has_many :beads_posts, :dependent => :destroy
has_many :beads, :through => :beads_posts
belongs_to :user

end
