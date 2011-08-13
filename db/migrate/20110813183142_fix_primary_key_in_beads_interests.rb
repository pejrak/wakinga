class FixPrimaryKeyInBeadsInterests < ActiveRecord::Migration
  def self.up
    add_column :beads_interests, :id, :primary_key
  end

  def self.down
    remove_column :beads_interests, :id
  end
end
