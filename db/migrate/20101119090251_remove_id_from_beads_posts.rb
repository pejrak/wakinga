class RemoveIdFromBeadsPosts < ActiveRecord::Migration
  def self.up
    remove_column :beads_posts, :id
  end

  def self.down
    add_column :beads_posts, :id, :integer
  end
end
