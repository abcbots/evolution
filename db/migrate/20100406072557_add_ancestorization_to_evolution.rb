class AddAncestorizationToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :ancestorization, :integer
  end

  def self.down
    remove_column :evolutions, :ancestorization
  end
end
