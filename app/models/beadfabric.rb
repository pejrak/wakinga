class Beadfabric < ActiveRecord::Base
belongs_to :bead
belongs_to :post
has_and_belongs_to_many :beadthreads
has_and_belongs_to_many :interests

end
