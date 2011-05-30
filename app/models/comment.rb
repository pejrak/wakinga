class Comment < ActiveRecord::Base
belongs_to :post
belongs_to :user

  MAX_BODY_LENGTH = 120
  validates :body, :presence => true, :length => { :minimum => 1, :maximum => MAX_BODY_LENGTH }

  def new?(user)
    (created_at > user.last_sign_in_at)? true : false
  end

end
