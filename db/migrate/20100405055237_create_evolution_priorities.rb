class CreateEvolutionPriorities < ActiveRecord::Migration
  def self.up
    create_table :evolution_priorities do |t|
      t.integer :id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :evolution_priorities
  end
end
