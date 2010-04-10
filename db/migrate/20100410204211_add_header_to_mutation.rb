class AddHeaderToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :header, :string
  end

  def self.down
    remove_column :mutations, :header
  end
end
