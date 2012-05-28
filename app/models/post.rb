class Post < ActiveRecord::Base

  #include Rhoconnect::Resource


  MAX_CONTENT_LENGTH = 620
  #associations
validates :content, :presence => true, :length => { :minimum => 5, :maximum => MAX_CONTENT_LENGTH }

  has_many :comments, :dependent => :destroy, :order => 'created_at ASC'
  has_many :beads_posts, :dependent => :destroy
  has_many :beads, :through => :beads_posts
  has_many :memorizations, :dependent => :destroy
  has_many :interests_posts, :dependent => :destroy
  has_many :interests, :through => :interests_posts
  belongs_to :user

#  def partition
#    lambda { self.user.username }
#  end

  #attr_accessor :interest_id

# memory search called here:
  def self.search(search,memory_array)
    find(:all, :include => :comments, :limit => 10, :conditions => ['posts.id IN (?) AND (UPPER(posts.content) LIKE UPPER(?) OR  UPPER(comments.body) LIKE UPPER(?))', memory_array, "%#{search}%", "%#{search}%"], :order => 'posts.updated_at DESC')
  end

  def new_comments_since_last_login(user)
    comments.where('created_at > ?', user.last_sign_in_at)
  end

  #here, I define the algorithm for message display time shift
  def display_time_at
    gm = self.good_memories.count
    bm = self.bad_memories.count
    lifespan = (Time.now.to_i - self.created_at.to_i)
    unless gm == 0
      shift = (lifespan * (bm + 1)) / gm
      return (Time.now.to_i - shift)
    else
      shift = lifespan * (bm + 1)
      return (Time.now.to_i - shift)
    end
  end

  #algorithm for finding marked messages is displayed here
  def live_message(selected_user,previous_visit_record=Time.now)
    loaded_associated_memorization = self.memorizations.where(:memorable => true, :user_id => selected_user.id).first
    if self.comments and loaded_associated_memorization
      if self.comments.where('comments.updated_at > ?', loaded_associated_memorization.updated_at).present?
        return true
      elsif previous_visit_record < self.updated_at and loaded_associated_memorization.updated_at > previous_visit_record
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
  
  def bad_memory(selected_user)
    memorizations.where(:memorable=>false,:user_id=>selected_user.id).first
  end

  def bad_memories
    memorizations.where(:memorable=>false)
  end

  def good_memories
    memorizations.where(:memorable=>true)
  end

  def memory_updated_at(selected_user)
    Memorization.find_by_user_id_and_post_id(selected_user.id, self.id).updated_at.to_i
  end

  def related_interest
    mapped_interest_id = self.interests_posts.map(&:interest_id).first
    return Interest.find(mapped_interest_id)
  end

  def good_memorizations_of_other_than(selected_user)
    self.memorizations.where('user_id <> ? AND memorable = ?', selected_user.id, true)

  end

  def other_memorizers(selected_user)
    #other_memorizer_ids = self.good_memorizations_of_other_than(selected_user).map(&:user_id)
    if self.related_interest
      related_trustors = self.related_interest.other_trustors(selected_user)
      (related_trustors)? other_memorizer_ids = self.memorizations.where(:user_id => related_trustors, :memorable => true).map(&:user_id) : other_memorizer_ids = []
      return User.find(other_memorizer_ids)
    else
      return []
    end

  end

end
