class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.integer :id
      t.string :name
      t.string :worker_class
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end