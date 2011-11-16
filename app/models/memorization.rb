class Memorization < ActiveRecord::Base
    attr_accessible :post_id, :user_id, :memorable, :updated_at, :change_record, :status_indication

  belongs_to :post
  belongs_to :user
  #strings fo memorization record handling
  MEMORY_AUTHORED = "#{Time.now.to_s}: Authored.\n"
  MEMORY_START = "#{Time.now.to_s}: Memorized.\n"
  MEMORY_MARKED_COMPLETE = "#{Time.now.to_s}: Marked complete. \n"
  MEMORY_MARKED_ACTION = "#{Time.now.to_s}: Marked for action. \n"
  MEMORY_ARCHIVED = "#{Time.now.to_s}: Moved to archive. \n"
  MEMORY_BURN = "#{Time.now.to_s}: Burned. \n"
  MEMORY_REVIEW = "#{Time.now.to_s}: Reviewed. \n"

end
