class AddStatusIndicationToMemorizations < ActiveRecord::Migration
  def self.up
    add_column :memorizations, :status_indication, :string
  end

  def self.down
    remove_column :memorizations, :status_indication
  end
end
