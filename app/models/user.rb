class User < ActiveRecord::Base
has_many :posts, :dependent => :destroy
has_many :comments
has_many :interests, :dependent => :destroy
has_many :beads_interests, :through => :interests
has_many :beads_posts, :through => :posts
has_many :memorizations

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable and :registerable, :activatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :login, :remember_me

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username, :email, :presence => true
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

  def good_memories
    memorizations.where(:memorable => true)
  end

  def burned_memories
    memorizations.where(:memorable => false)
  end

  def good_memories_by_others
    Memorization.where(:post_id => posts, :memorable => true)
  end

  def burned_memories_by_others
    Memorization.where(:post_id => posts, :memorable => false)
  end

  def rating_total
    posts.sum('rating')
  end

  def to_param
    "#{id}-#{username}"
  end

  protected

   def self.find_for_database_authentication(conditions)
     login = conditions.delete(:login)
     where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
   end

end
