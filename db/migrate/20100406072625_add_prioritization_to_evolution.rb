class AddPrioritizationToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :prioritization, :integer
  end

  def self.down
    remove_column :evolutions, :prioritization
  end
end
