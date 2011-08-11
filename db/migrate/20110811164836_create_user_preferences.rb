class CreateUserPreferences < ActiveRecord::Migration
#rails g nifty:scaffold UserPreference subscription_preference:string messages_per_page:integer user_id:integer
  def self.up
    create_table :user_preferences do |t|
      t.string :subscription_preference
      t.integer :messages_per_page
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_preferences
  end
end
