class RemoveIdFromBeadsInterests < ActiveRecord::Migration
  def self.up
    remove_column :beads_interests, :id
  end

  def self.down
    add_column :beads_interests, :id, :integer
  end
end
