class Request < ActiveRecord::Base
    attr_accessible :r_type, :r_title, :r_description, :r_priority, :r_status, :user_id
end
