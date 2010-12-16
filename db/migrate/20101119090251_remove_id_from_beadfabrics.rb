class RemoveIdFromBeadfabrics < ActiveRecord::Migration
  def self.up
    remove_column :beadfabrics, :id
  end

  def self.down
    add_column :beadfabrics, :id, :integer
  end
end
