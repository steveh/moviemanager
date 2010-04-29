require "cgi"
require "net/http"

module Sources
  class RottenTomatoes < Base
    def initialize
      @@rotten_tomatoes = Net::HTTP.start("au.rottentomatoes.com", 80)
    end

    def search(title)
      request = "/search/full_search.php?search=%s" % CGI.escape(title)
      response = @@rotten_tomatoes.get(request, headers)
      [request, response]
    end
    
    def parse(response)
      results = []
      doc = Hpricot(response.body)
      (doc/"td.title a").each do |row|        
        if row['href'] =~ /\/m\/(.*)\//
          results << { :title => row.inner_text, :id => $1, :url => "http://au.rottentomatoes.com/m/#{$1}/"}
        end
      end
      results
    end
  end
end