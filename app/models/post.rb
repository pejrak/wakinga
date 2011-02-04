class Post < ActiveRecord::Base
validates :title, :presence => true, :length => { :minimum => 5 } 

  #associations
has_many :comments, :dependent => :destroy
has_many :beads_posts
has_many :beads, :through => :beads_posts
belongs_to :user

end
