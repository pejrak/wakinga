class Bead < ActiveRecord::Base
has_many :beadfabrics
has_many :beadthreads
has_and_belongs_to_many :interests
has_and_belongs_to_many :users
has_many :posts, :through => :beadfabrics
end
