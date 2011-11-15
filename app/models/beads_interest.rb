class BeadsInterest < ActiveRecord::Base
    attr_accessible :bead_id, :interest_id

  belongs_to :bead
  belongs_to :interest
  has_many :user_interest_preferences, :through => :interest
  
end
