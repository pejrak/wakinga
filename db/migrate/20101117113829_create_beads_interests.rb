class CreateBeadsInterests < ActiveRecord::Migration
  def self.up
    create_table :beads_interests do |t|
      t.integer :interest_id
      t.integer :bead_id
    end
  end

  def self.down
    drop_table :beads_interests
  end
end
