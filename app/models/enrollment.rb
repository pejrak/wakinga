class Enrollment < ActiveRecord::Base
    attr_accessible :email, :ein
    attr_accessor :ein  
    
  validates :email, :presence => true
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, :message => "email is wrong"

  protected

  def email_must_be_real
    unless email.gsub(/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/,"").size > 6
      errors.add(:email, 'must be real')
    end
  end




end
