class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :id
      t.integer :source_id
      t.integer :movie_id
      t.text :request
      t.text :response
      t.timestamps
      t.datetime :requested_at
      t.datetime :processed_at
    end
  end

  def self.down
    drop_table :searches
  end
end