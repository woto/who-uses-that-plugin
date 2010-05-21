class CreateApplicationsUsers < ActiveRecord::Migration
  def self.up
    create_table :applications_users do |t|
      t.references :user
      t.references :application

      t.timestamps
    end
  end

  def self.down
    drop_table :applications_users
  end
end
