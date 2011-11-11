class CreateUserInterestPreferences < ActiveRecord::Migration
  def self.up
    create_table :user_interest_preferences do |t|
      t.integer :user_id
      t.integer :interest_id
      t.datetime :last_visit_at
      t.boolean :i_private

      t.timestamps
    end
  end

  def self.down
    drop_table :user_interest_preferences
  end
end
