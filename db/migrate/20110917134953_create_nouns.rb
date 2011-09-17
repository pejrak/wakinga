class CreateNouns < ActiveRecord::Migration
  def self.up
    create_table :nouns do |t|
      t.string :title
      t.boolean :b_active
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :nouns
  end
end
