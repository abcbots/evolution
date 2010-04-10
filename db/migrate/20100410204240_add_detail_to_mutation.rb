class AddDetailToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :detail, :text
  end

  def self.down
    remove_column :mutations, :detail
  end
end
