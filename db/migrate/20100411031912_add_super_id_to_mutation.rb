class AddSuperIdToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :super_id, :integer
  end

  def self.down
    remove_column :mutations, :super_id
  end
end
