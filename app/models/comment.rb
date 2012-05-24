class Comment < ActiveRecord::Base

#    include Rhoconnect::Resource

  belongs_to :post
  belongs_to :user

  MAX_BODY_LENGTH = 300
  validates :body, :presence => true, :length => { :minimum => 1, :maximum => MAX_BODY_LENGTH }

#  def partition
#    lambda { self.user.username }
#  end

  def new?(selected_user)
#    loaded_post_memorization = post.memorizations.where(:memorable => true, :user_id => selected_user.id).first
#    if loaded_post_memorization
#      (updated_at > loaded_post_memorization.updated_at)? true : false
#    else
    (updated_at > selected_user.last_sign_in_at)? true : false
#    end
  end

end
