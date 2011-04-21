class BeadsPost < ActiveRecord::Base
    attr_accessible :bead_id, :post_id

  belongs_to :post
  belongs_to :bead, :counter_cache => true
  
end