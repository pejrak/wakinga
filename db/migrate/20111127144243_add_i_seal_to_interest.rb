class AddISealToInterest < ActiveRecord::Migration
  def self.up
    add_column :interests, :i_seal, :boolean, :default => false
  end

  def self.down
    remove_column :interests, :i_seal
  end
end
