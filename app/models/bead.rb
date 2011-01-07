class Bead < ActiveRecord::Base
has_and_belongs_to_many :interests
has_and_belongs_to_many :posts
accepts_nested_attributes_for :interests, :allow_destroy => true
accepts_nested_attributes_for :posts, :allow_destroy => true
end
