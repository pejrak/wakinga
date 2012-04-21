class InterestsPost < ActiveRecord::Base

  attr_accessible :post_id, :interest_id

  belongs_to :post
  belongs_to :interest

end
