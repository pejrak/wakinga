class RemovePreferencesFromInterests < ActiveRecord::Migration
  def self.up
    remove_column :interests, :last_visit_at
    remove_column :interests, :feed_url
    remove_column :interests, :i_private
  end

  def self.down
    add_column :interests, :i_private, :boolean
    add_column :interests, :feed_url, :string
    add_column :interests, :last_visit_at, :datetime
  end
end
