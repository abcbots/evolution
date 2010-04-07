class AddFeatureIdToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :feature_id, :integer
  end

  def self.down
    remove_column :evolutions, :feature_id
  end
end
