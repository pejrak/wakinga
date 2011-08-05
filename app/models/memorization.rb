class Memorization < ActiveRecord::Base
    attr_accessible :post_id, :user_id, :memorable, :updated_at

  belongs_to :post
  belongs_to :user
  
end
