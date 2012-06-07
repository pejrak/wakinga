class ChangeColumnInPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.change :p_private, :integer
    end
  end

  def self.down
    change_table :posts do |t|
      t.change :p_private, :boolean
    end
  end
end
