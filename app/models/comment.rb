class Comment < ActiveRecord::Base
belongs_to :post
belongs_to :user

  validates :body, :presence => true, :length => { :minimum => 1, :maximum => 320 }
end
