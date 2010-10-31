class CreateServiceFriends < ActiveRecord::Migration
  def self.up
    create_table :service_friends do |t|
      t.references :service
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :service_friends
  end
end
