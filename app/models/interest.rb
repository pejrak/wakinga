class Interest < ActiveRecord::Base
has_many :beadthreads
has_many :beads, :through => :beadthreads
has_and_belongs_to_many :beadfabrics
has_and_belongs_to_many :posts
belongs_to :user
validates_associated :beadfabrics

end
