class MakeSearchResultsLongtext < ActiveRecord::Migration
  def self.up
    change_column :searches, :response, :longtext
  end

  def self.down
    change_column :searches, :response, :text
  end
end
