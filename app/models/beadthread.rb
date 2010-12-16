class Beadthread < ActiveRecord::Base
belongs_to :bead
belongs_to :interest
belongs_to :user
has_and_belongs_to_many :beadfabrics
has_and_belongs_to_many :posts
end
