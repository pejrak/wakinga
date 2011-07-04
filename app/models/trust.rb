class Trust < ActiveRecord::Base
    attr_accessible :trustee_id, :interest_id

  belongs_to :interest
  belongs_to :trustee, :class_name => "User"
end
