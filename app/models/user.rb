class User < ActiveRecord::Base
has_many :posts, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :beads_posts, :through => :posts
has_many :memorizations
has_many :authentications
has_many :trusts, :dependent => :destroy, :foreign_key => 'trustor_id'
has_many :trusts, :dependent => :destroy, :foreign_key => 'trustee_id'
has_one :user_preference, :dependent => :destroy
has_many :user_interest_preferences, :dependent => :destroy
# Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable and :registerable, :activatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :login, :remember_me, :role

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates_length_of :username, :within => 3..40
  validates_uniqueness_of :username, :case_sensitive => false

  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email, :case_sensitive => false
  
  def as_json(options={})
    super(:only => [:email, :username, :role] )
  end

# user search called here:
  def self.search(search)
    find(:all, :limit => 10, :conditions => ['(UPPER(users.username) LIKE UPPER(?) OR  UPPER(users.email) LIKE UPPER(?))', "%#{search}%", "%#{search}%"], :order => 'users.username ASC')
  end

  def online?
    updated_at > 10.minutes.ago
  end

  def trustees
    Trust.where(:trustor_id => self.id).map(&:trustee_id).uniq
  end

  def rating_on_beads
    BeadsPost.find(:all,
    :select => 'bead_id, beads.title, sum(posts.rating) as rating_sum',
    :joins => [:bead, :post],
    :conditions => ["posts.user_id = ?", id],
    :group => ['bead_id','beads.title'],
    :order => 'rating_sum DESC',
    :limit => 5)
  end

  def users_interests_with_selected_bead(selected_bead) 
    #returns array of interest ids having the selected bead
    return BeadsInterest.find(:all, :joins => [:bead, :interest], :conditions => ['interests.user_id = ? AND beads.id = ?', self.id, selected_bead.id]).map(&:interest_id)
  end

  def users_prefered_interests
    users_public_interest_preferences = user_interest_preferences.where(:i_private => false).map(&:interest_id)
    return Interest.where(:id => users_public_interest_preferences)
  end

  def users_prefered_interests_all
    users_all_interest_preferences = user_interest_preferences.map(&:interest_id)
    return Interest.where(:id => users_all_interest_preferences).sort_by { |i| -Interest.find(i).memorized_post_content(true,self).size }
  end

#take all interests of current user
#selected user is the trustee
#do not offer interests that are already trusted to the trustee
  def interests_for_trust(trustee)
    offered_interests = Trust.where('trusts.trustor_id = ? AND trustee_id = ?', self.id, trustee.id).map(&:interest_id)
    interest_ids_to_offer = user_interest_preferences.map(&:interest_id) - offered_interests
    return Interest.where(:id => interest_ids_to_offer)
  end

  def good_memories
    memorizations.where(:memorable => true)
  end

  def burned_memories
    memorizations.where(:memorable => false)
  end

  def good_memories_by_others
    Memorization.where('memorizations.post_id IN (?) AND memorizations.memorable = ? AND memorizations.user_id <> ?', posts, true, self)
  end

  def burned_memories_by_others
    Memorization.where('memorizations.post_id IN (?) AND memorizations.memorable = ? AND memorizations.user_id <> ?', posts, false, self)
  end

  def rating_total
    posts.sum('rating')
  end


  #load all live memories, those having recently added comments to them
  def live_memories
    memes = memorizations.joins(:comments).where('memorizations.memorable = ? AND comments.updated_at > memorizations.updated_at', true).map(&:post_id) | memorizations.joins(:post).where('memorizations.updated_at = memorizations.created_at AND memorizations.user_id <> posts.user_id AND memorizations.memorable = ?', true).map(&:post_id)
    return Post.where(:id => memes)
  end

  def posts_with_new_memories
    memes = memorizations.joins(:post).where('memorizations.updated_at = memorizations.created_at AND memorizations.user_id <> posts.user_id').map(&:post_id) | memorizations.joins(:comments).where('memorizations.memorable = ? AND comments.updated_at > memorizations.updated_at', true).map(&:post_id)
    return memes
  end

#  def to_param
#    "#{id}-#{username.parameterize}"
#  end

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def outgoing_trusts
    Trust.where(:interest_id => interests)
  end

  def incoming_trusts
    unconfirmed_incoming_trusts = []
    all_incoming_trusts = Trust.where(:trustee_id => self.id)
    all_incoming_trusts.each do |t|
      if t.confirmed? == false
        unconfirmed_incoming_trusts << t
      end
    end
    return unconfirmed_incoming_trusts
  end

  protected

   def self.find_for_database_authentication(conditions)
     login = conditions.delete(:login)
     where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
   end

end
