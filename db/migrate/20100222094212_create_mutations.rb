class CreateMutations < ActiveRecord::Migration
  def self.up
    create_table :mutations do |t|
      t.integer :mutation_id
      t.integer :evolution_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :mutations
  end
end
