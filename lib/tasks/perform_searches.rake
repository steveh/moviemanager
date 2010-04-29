task :perform_searches => :environment do |t|
  searches = Search.unrequested(:include => [:movie, :source])

  searches.each do |search|
    puts "Searching for #{search.movie.title} at #{search.source.name}"

    begin
      worker = search.source.worker

      request, response = *worker.search(search.movie.title)

      search.update_attributes!(
       :request => request.to_yaml,
       :response => response.to_yaml,
       :requested_at => Time.now
      )

      #sleep 1
    rescue
      puts "\tFailed"
    end
  end
end

task :parse_searches => :environment do |t|
  searches = Search.unprocessed(:include => [:movie, :source])
  
  searches.each do |search|
    SearchResult.transaction do
      response = YAML.load(search.response)
      results = search.source.worker.parse(response)
    
      results.each do |result|
        SearchResult.create!(
          :search_id => search,
          :source_id => result[:id],
          :title => result[:title] || search.movie.title,
          :url => result[:url]
        )
      end
        
      search.update_attributes!(
        :processed_at => Time.now
      )
    end
  end
end