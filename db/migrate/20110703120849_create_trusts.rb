class CreateTrusts < ActiveRecord::Migration
  def self.up
    create_table :trusts do |t|
      t.integer :trustee_id
      t.integer :interest_id
      t.timestamps
    end
  end

  def self.down
    drop_table :trusts
  end
end
