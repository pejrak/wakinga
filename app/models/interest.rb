class Interest < ActiveRecord::Base
has_and_belongs_to_many :beads, :include => [ :posts ]

belongs_to :user
#nested attribute definition
accepts_nested_attributes_for :beads

end
