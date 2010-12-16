class CreateBeadthreads < ActiveRecord::Migration
  def self.up
    create_table :beadthreads do |t|
      t.integer :interest_id
      t.integer :bead_id

      t.timestamps
    end
  end

  def self.down
    drop_table :beadthreads
  end
end
