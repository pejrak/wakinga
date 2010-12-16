class Post < ActiveRecord::Base
validates :title, :presence => true, :length => { :minimum => 5 } 
belongs_to :user
has_many :beadfabrics
has_many :beads, :through => :beadfabrics
has_and_belongs_to_many :beadthreads
has_many :comments, :dependent => :destroy
has_and_belongs_to_many :interests

end
