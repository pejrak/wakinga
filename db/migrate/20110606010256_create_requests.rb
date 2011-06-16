class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.string :r_type
      t.string :r_title
      t.text :r_description
      t.string :r_priority
      t.string :r_status
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
