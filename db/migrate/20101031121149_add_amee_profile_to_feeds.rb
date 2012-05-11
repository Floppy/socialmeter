class AddAmeeProfileToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :amee_profile, :string
  end

  def self.down
    remove_column :feeds, :amee_profile
  end
end
