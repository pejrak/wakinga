class FixColumnInPosts < ActiveRecord::Migration
  def self.up
    rename_column :posts, :private, :p_private
  end

  def self.down
    rename_column :posts, :p_private, :private
  end
end
