class AddAncestorizationToEvolutionPriority < ActiveRecord::Migration
  def self.up
    add_column :evolution_priorities, :ancestorization, :integer
  end

  def self.down
    remove_column :evolution_priorities, :ancestorization
  end
end
