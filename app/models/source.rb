class Source < ActiveRecord::Base
  has_many :searches
  
  def worker
    @worker ||= get_class(worker_class).new
  end
end