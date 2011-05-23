class Comment < ActiveRecord::Base
belongs_to :post
belongs_to :user

  validates :body, :presence => true, :length => { :minimum => 1, :maximum => 320 }

  def new?(user)
    (created_at > user.last_sign_in_at)? true : false
  end

end
