class ChangeFloatTypesInFeeds < ActiveRecord::Migration
  def self.up
    change_column :feeds, :current_value, :float
    change_column :feeds, :current_carbon, :float
  end

  def self.down
    change_column :feeds, :current_value, :decimal
    change_column :feeds, :current_carbon, :decimal
  end
end
