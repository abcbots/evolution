class AddShowFormattingToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :show_formatting, :boolean
  end

  def self.down
    remove_column :evolutions, :show_formatting
  end
end
