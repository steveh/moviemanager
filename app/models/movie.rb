class Movie < ActiveRecord::Base
  has_many :searches
  
  named_scope :without_all_sources, lambda { { :conditions => { :id => without_all_sources_ids } } }
  
  private
  
    def self.without_all_sources_ids
      find_by_sql(<<-EOF
SELECT
  mo.id movie_id,
  COUNT(so.id) num_sources
FROM movies mo
LEFT JOIN searches se ON se.movie_id = mo.id
LEFT JOIN sources so ON so.id = se.source_id
GROUP BY mo.id
HAVING num_sources < (SELECT COUNT(*) FROM sources)
EOF
      ).collect { |result| result['movie_id'].to_i }
    end

end