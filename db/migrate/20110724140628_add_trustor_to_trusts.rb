class AddTrustorToTrusts < ActiveRecord::Migration
  def self.up
    add_column :trusts, :trustor_id, :integer
  end

  def self.down
    remove_column :trusts, :trustor_id
  end
end
