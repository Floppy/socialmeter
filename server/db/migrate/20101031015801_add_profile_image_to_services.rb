class AddProfileImageToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :profile_image_url, :string
  end

  def self.down
    remove_column :services, :profile_image_url
  end
end
