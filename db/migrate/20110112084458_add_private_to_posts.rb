class AddPrivateToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :private, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :private
  end
end
