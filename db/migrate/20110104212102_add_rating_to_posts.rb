class AddRatingToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :rating, :integer
  end

  def self.down
    remove_column :posts, :rating
  end
end
