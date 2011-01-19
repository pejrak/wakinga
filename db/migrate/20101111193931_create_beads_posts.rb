class CreateBeadsPosts < ActiveRecord::Migration
  def self.up
    create_table :beads_posts do |t|
      t.integer :bead_id
      t.integer :post_id
    end
  end

  def self.down
    drop_table :beads_posts
  end
end
