class AddChildlessToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :childless, :boolean
  end

  def self.down
    remove_column :mutations, :childless
  end
end
