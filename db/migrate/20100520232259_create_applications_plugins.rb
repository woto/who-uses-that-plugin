class CreateApplicationsPlugins < ActiveRecord::Migration
  def self.up
    create_table :applications_plugins, :id => false do |t|
      t.references :application
      t.references :plugin

      t.timestamps
    end
  end

  def self.down
    drop_table :applications_plugins
  end
end
