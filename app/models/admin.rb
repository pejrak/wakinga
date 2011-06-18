class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable, :validatable, :registerable, :confirmable, :recoverable, :rememberable
  devise :database_authenticatable, :trackable, :timeoutable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :login

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  protected

   def self.find_for_database_authentication(conditions)
     login = conditions.delete(:login)
     where(conditions).where(["email = :value", { :value => login }]).first
   end
   
end
