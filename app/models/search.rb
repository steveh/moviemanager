class Search < ActiveRecord::Base
  belongs_to :source
  belongs_to :movie
  
  named_scope :requested, :conditions => ["requested_at IS NOT NULL"]
  named_scope :unrequested, :conditions => ["requested_at IS NULL"]
  named_scope :processed, :conditions => ["requested_at IS NOT NULL AND processed_at IS NOT NULL"]
  named_scope :unprocessed, :conditions => ["requested_at IS NOT NULL AND processed_at IS NULL"]
end
