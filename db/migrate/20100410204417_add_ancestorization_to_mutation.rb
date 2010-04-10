class AddAncestorizationToMutation < ActiveRecord::Migration
  def self.up
    add_column :mutations, :ancestorization, :integer
  end

  def self.down
    remove_column :mutations, :ancestorization
  end
end
