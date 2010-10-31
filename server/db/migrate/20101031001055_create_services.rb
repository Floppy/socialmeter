class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :service_name
      t.string :external_id
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
