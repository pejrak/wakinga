class AddTitleToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :title, :string
  end

  def self.down
    remove_column :interests, :title
  end
end
