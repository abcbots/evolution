class AddSuperIdToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :super_id, :integer
  end

  def self.down
    remove_column :evolutions, :super_id
  end
end
