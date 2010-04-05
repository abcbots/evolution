class AddMutationIdToEvolutionPriority < ActiveRecord::Migration
  def self.up
    add_column :evolution_priorities, :mutation_id, :integer
  end

  def self.down
    remove_column :evolution_priorities, :mutation_id
  end
end
