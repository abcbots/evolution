class AddStartTimeToEvolution < ActiveRecord::Migration
  def self.up
    add_column :evolutions, :start_time, :datetime
  end

  def self.down
    remove_column :evolutions, :start_time
  end
end
