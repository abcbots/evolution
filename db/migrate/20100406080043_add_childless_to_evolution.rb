class AddChildlessToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :childless, :boolean
  end

  def self.down
    remove_column :evolutions, :childless
  end
end
