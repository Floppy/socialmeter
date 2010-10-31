class AddAveragedValuesToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :average_value, :float, :default => 0.0
    add_column :feeds, :average_carbon, :float, :default => 0.0
  end

  def self.down
    remove_column :feeds, :average_carbon
    remove_column :feeds, :average_value
  end
end
