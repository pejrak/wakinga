class AddPrivateToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :i_private, :boolean
  end

  def self.down
    remove_column :interests, :i_private
  end
end
