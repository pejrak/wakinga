class Post < ActiveRecord::Base
validates :title, :presence => true, :length => { :minimum => 5 } 

  #associations
has_many :comments, :dependent => :destroy
has_and_belongs_to_many :beads
belongs_to :user

accepts_nested_attributes_for :beads
end
