class Bead < ActiveRecord::Base
has_and_belongs_to_many :interests
has_and_belongs_to_many :posts
accepts_nested_attributes_for :interests, :allow_destroy => true
accepts_nested_attributes_for :posts, :allow_destroy => true

  def self.search(search)
    if search
      find(:all, :limit => 30, :conditions => ['title OR description LIKE ?', "%#{search}%"])
    else
      find(:all, :limit => 10 )
    end
  end

end
