require "cgi"
require "net/http"

module Sources
  class MetaCritic < Base
    def initialize
      @@metacritic = Net::HTTP.start("www.metacritic.com", 80)
    end

    def search(title)
      request = "/search/process?sort=relevance&termtype=all&ts=%s&ty=1&button=search" % CGI.escape(title)
      response = @@metacritic.get(request, headers)
      [request, response]
    end
    
    def parse(response)
      results = []

      doc = Hpricot(response.body)
      (doc/"#rightcolumn p a").each do |row|
        if row['href'] =~ /\/video\/titles\/(.*)\?q=/
          results << { :title => row.inner_text, :id => $1, :url => "http://www.metacritic.com/film/titles/#{$1}"}
        end
      end
      results
    end
  end
end