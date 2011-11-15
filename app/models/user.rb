class User < ActiveRecord::Base
has_many :posts, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :interests, :dependent => :destroy
has_many :beads_interests, :through => :interests
has_many :beads_posts, :through => :posts
has_many :memorizations
has_many :authentications
has_many :trusts, :dependent => :destroy, :foreign_key => 'trustor_id'
has_many :trusts, :dependent => :destroy, :foreign_key => 'trustee_id'
has_one :user_preference, :dependent => :destroy
has_many :user_interest_preferences, :dependent => :destroy
# Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable and :registerable, :activatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :login, :remember_me

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates_length_of :username, :within => 3..40
  validates_uniqueness_of :username, :case_sensitive => false

  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email, :case_sensitive => false

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

#take all interests of current user
#selected user is the trustee
#do not offer interests that are already trusted to the trustee
	def interests_for_trust(trustee)
		return interests - interests.joins(:trusts).where('trusts.trustee_id = ?',trustee)
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
