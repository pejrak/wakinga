class UserPreference < ActiveRecord::Base
  attr_accessible :subscription_preference, :messages_per_page, :user_id

  belongs_to :user

  #setting defaults for preferences

  SUBSCRIPTION_PREFERENCE_OPTIONS = ['Daily','Weekly','None']
  MESSAGE_PER_PAGE_OPTIONS = [30,50,100]

end
