class AddBeadsPostsCountToBeads < ActiveRecord::Migration
  def self.up
    add_column :beads, :beads_posts_count, :integer, :default => 0
  end

  def self.down
    remove_column :beads, :beads_posts_count
  end
end
