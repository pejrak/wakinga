class RemoveUserIdFromInterests < ActiveRecord::Migration
#rails g migration RemoveUserIdFromInterests
  def self.up
    remove_column :interests, :user_id
  end

  def self.down
    add_column :interests, :id, :integer
  end
end
