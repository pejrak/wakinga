class Post < ActiveRecord::Base
#validates :title, :presence => true, :length => { :minimum => 2, :maximum => 50 }


  MAX_CONTENT_LENGTH = 320
  #associations
validates :content, :presence => true, :length => { :minimum => 5, :maximum => MAX_CONTENT_LENGTH }

  has_many :comments, :dependent => :destroy
  has_many :beads_posts, :dependent => :destroy
  has_many :beads, :through => :beads_posts
  has_many :memorizations, :dependent => :destroy
  belongs_to :user
  
# memory search called here:
  def self.search(search,memory_array)
    find(:all, :include => :comments, :limit => 11, :conditions => ['posts.id IN (?) AND (UPPER(posts.content) LIKE UPPER(?) OR  UPPER(comments.body) LIKE UPPER(?))', memory_array, "%#{search}%", "%#{search}%"], :order => 'posts.updated_at DESC')
  end

  def new_comments_since_last_login(user)
    comments.where('created_at > ?', user.last_sign_in_at)
  end

  def live_message(selected_user,previous_visit_record)
    loaded_associated_memorization = self.memorizations.where(:memorable => true, :user_id => selected_user.id).first
    if self.comments and loaded_associated_memorization
      if self.comments.where('comments.updated_at > ?', loaded_associated_memorization.updated_at).present?
        return true
      elsif  previous_visit_record < self.updated_at && loaded_associated_memorization.updated_at > previous_visit_record
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def good_memory(selected_user)
    memorizations.where(:memorable=>true,:user_id=>selected_user.id).first
  end
end
