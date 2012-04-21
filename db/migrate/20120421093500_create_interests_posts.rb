class CreateInterestsPosts < ActiveRecord::Migration
  def self.up
    create_table :interests_posts do |t|
      t.integer :interest_id
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :interests_posts
  end
end
