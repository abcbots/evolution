class AddPrioritizationToEvolutionPriority < ActiveRecord::Migration
  def self.up
    add_column :evolution_priorities, :prioritization, :integer
  end

  def self.down
    remove_column :evolution_priorities, :prioritization
  end
end
