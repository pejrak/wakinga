class RemoveIdFromBeadthreads < ActiveRecord::Migration
  def self.up
    remove_column :beadthreads, :id
  end

  def self.down
    add_column :beadthreads, :id, :integer
  end
end
