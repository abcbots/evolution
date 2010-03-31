class AddHeaderToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :header, :string
  end

  def self.down
    remove_column :evolutions, :header
  end
end
