class RemoveBeadIdFromInterests < ActiveRecord::Migration
  def self.up
    remove_column :interests, :bead_id
  end

  def self.down
    add_column :interests, :bead_id, :integer
  end
end
