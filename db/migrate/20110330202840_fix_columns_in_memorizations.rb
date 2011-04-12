class FixColumnsInMemorizations < ActiveRecord::Migration
  def self.up
    add_column :memorizations, :memorable, :boolean
  end

  def self.down
    remove_column :memorizations, :memorable
  end
end
