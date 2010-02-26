class AddCompletedAtToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :completed_at, :datetime
  end

  def self.down
    remove_column :mutations, :completed_at
  end
end
