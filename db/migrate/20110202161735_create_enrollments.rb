class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
