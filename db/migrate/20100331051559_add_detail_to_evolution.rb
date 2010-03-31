class AddDetailToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :detail, :text
  end

  def self.down
    remove_column :evolutions, :detail
  end
end
