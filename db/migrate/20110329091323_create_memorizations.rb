class CreateMemorizations < ActiveRecord::Migration
  def self.up
    create_table :memorizations do |t|
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :memorizations
  end
end
