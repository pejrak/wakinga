class Post < ActiveRecord::Base
#validates :title, :presence => true, :length => { :minimum => 2, :maximum => 50 }
validates :content, :presence => true, :length => { :minimum => 5, :maximum => 320 }

  #associations
has_many :comments, :dependent => :destroy
has_many :beads_posts, :dependent => :delete_all
has_many :beads, :through => :beads_posts
has_many :memorizations, :dependent => :delete_all
belongs_to :user

  def new_comments_since_last_login(user)
    comments.where('created_at > ?', user.last_sign_in_at)
  end
end
