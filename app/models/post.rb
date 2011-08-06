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

  def live_message(selected_user)
    loaded_associated_memorization = self.memorizations.where(:memorable => true, :user_id => selected_user.id).first
    if self.comments and loaded_associated_memorization
      if self.comments.where('comments.updated_at > ?', loaded_associated_memorization.updated_at).present?
        return true
      else
        return false
      end
    else
      return false
    end
  end

end
