class Post < ActiveRecord::Base
#validates :title, :presence => true, :length => { :minimum => 2, :maximum => 50 }


  MAX_CONTENT_LENGTH = 320
  #associations
validates :content, :presence => true, :length => { :minimum => 5, :maximum => MAX_CONTENT_LENGTH }

  has_many :comments, :dependent => :destroy
  has_many :beads_posts, :dependent => :delete_all
  has_many :beads, :through => :beads_posts
  has_many :memorizations, :dependent => :delete_all
  belongs_to :user

  def new_comments_since_last_login(user)
    comments.where('created_at > ?', user.last_sign_in_at)
  end
end
