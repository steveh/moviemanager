task :create_searches => :environment do |t|
  sources = Source.all
  Movie.without_all_sources.each do |movie|
    sources.each do |source|
      existing = movie.searches.find_by_source_id(source)
      movie.searches.create!(:source => source) unless existing
    end
  end
end