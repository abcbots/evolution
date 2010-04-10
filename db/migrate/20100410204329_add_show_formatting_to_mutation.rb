class AddShowFormattingToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :show_formatting, :boolean
  end

  def self.down
    remove_column :mutations, :show_formatting
  end
end
