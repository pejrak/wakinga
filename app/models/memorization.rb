class Memorization < ActiveRecord::Base
    attr_accessible :post_id, :user_id, :memorable, :updated_at, :change_record, :status_indication

  belongs_to :post
  belongs_to :user
  has_many :comments, :through => :post
  #strings fo memorization record handling
  MEMORY_AUTHORED = ": Authored.\n"
  MEMORY_START = ": Memorized.\n"
  MEMORY_MARKED_COMPLETE = ": Marked complete. \n"
  MEMORY_MARKED_ACTION = ": Marked for action. \n"
  MEMORY_ARCHIVED = ": Moved to archive. \n"
  MEMORY_BURN = ": Burned. \n"
  MEMORY_REVIEW = ": Reviewed. \n"
  MEMORY_GIVEN = ": Shared from author.\n"


end
