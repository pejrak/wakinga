class AddFeedUrlToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :feed_url, :string
  end

  def self.down
    remove_column :interests, :feed_url
  end
end
