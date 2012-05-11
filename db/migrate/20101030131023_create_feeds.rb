class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.decimal :current_value
      t.string :unit
      t.decimal :current_carbon
      t.string :energy_type
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
