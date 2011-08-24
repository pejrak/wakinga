class AddIdToBeadsPosts < ActiveRecord::Migration
  def self.up
    add_column :beads_posts, :id, :primary_key
  end

  def self.down
    remove_column :beads_posts, :id
  end
end
