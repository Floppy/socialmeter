class AddExternalIdToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :external_id, :string
    remove_column :feeds, :unit
    add_index :feeds, :external_id
  end

  def self.down
    remove_column :feeds, :external_id
    add_column :feeds, :unit, :string
  end
end
