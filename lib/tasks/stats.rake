task :movie_stats => :environment do |t|
  Movie.transaction do
    all_movies = Movie.count
    all_sources = Source.count
    all_searches = Search.count
    searches_not_created = Movie.without_all_sources.count
    searches_not_started = Search.unrequested.count
    searches_not_processed = Search.unprocessed.count
    searches_processed = Search.processed.count
    searches_unaccounted = all_searches - searches_not_created - searches_not_started - searches_not_processed - searches_processed
  
    puts "#{all_movies} movies"
    puts "#{all_sources} sources"
    puts "#{all_searches} searches"
    puts "#{searches_not_created} searches not created"
    puts "#{searches_not_started} searches not started"
    puts "#{searches_not_processed} searches not processed"
    puts "#{searches_processed} searches completed"
    puts "#{searches_unaccounted} searches unaccounted for"
  end
end