class AddEvolutionIdToEvolutionPriority < ActiveRecord::Migration
  def self.up
    add_column :evolution_priorities, :evolution_id, :integer
  end

  def self.down
    remove_column :evolution_priorities, :evolution_id
  end
end
