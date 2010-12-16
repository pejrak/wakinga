class CreateBeadfabrics < ActiveRecord::Migration
  def self.up
    create_table :beadfabrics do |t|
      t.integer :bead_id
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :beadfabrics
  end
end
