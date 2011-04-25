class AddLastVisitAtToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :last_visit_at, :datetime
  end

  def self.down
    remove_column :interests, :last_visit_at
  end
end
