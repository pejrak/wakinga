class AddParentBeadToBeads < ActiveRecord::Migration
  def self.up
    add_column :beads, :parent_bead, :boolean
  end

  def self.down
    remove_column :beads, :parent_bead
  end
end
