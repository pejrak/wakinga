class User < ActiveRecord::Base
has_many :posts, :dependent => :destroy
has_many :comments
has_many :interests, :dependent => :destroy
has_many :beads_interests, :through => :interests
has_many :beads_posts, :through => :posts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable and :registerable, :activatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :login, :remember_me

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :login, :email, :presence => true
  validates_length_of :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false

  validates_length_of :name, :maximum => 100

  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email, :case_sensitive => false

  def rating_on_beads
    BeadsPost.find(:all,
    :select => 'bead_id, beads.title, sum(posts.rating) as rating_sum, posts.user_id',
    :joins => [:bead, :post],
    :conditions => ["posts.user_id = ?", id],
    :group => 'bead_id',
    :order => 'rating_sum DESC',
    :limit => 5)
  end

  def rating_total
    posts.sum('rating')
  end

  protected

   def self.find_for_database_authentication(conditions)
     login = conditions.delete(:login)
     where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
   end

end
