class AddPrioritizationToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :prioritization, :integer
  end

  def self.down
    remove_column :mutations, :prioritization
  end
end
