class AddChangeRecordToMemorizations < ActiveRecord::Migration
  def self.up
    add_column :memorizations, :change_record, :text
  end

  def self.down
    remove_column :memorizations, :change_record
  end
end
