class User < ActiveRecord::Base
has_many :posts, :dependent => :destroy
has_many :comments
has_many :interests, :dependent => :destroy
has_many :beadthreads, :through => :interests

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation

end
