class RemoveNameFromPost < ActiveRecord::Migration
  def self.up
    remove_column :posts, :name
  end

  def self.down
    add_column :posts, :name, :string
  end
end
