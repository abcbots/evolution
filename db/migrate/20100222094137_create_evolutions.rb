class CreateEvolutions < ActiveRecord::Migration
  def self.up
    create_table :evolutions do |t|
      t.integer :evolution_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :evolutions
  end
end
