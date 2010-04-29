class CreateSearchResults < ActiveRecord::Migration
  def self.up
    create_table :search_results do |t|
      t.integer :id
      t.integer :search_id
      t.string :source_id
      t.string :title
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :search_results
  end
end
