require "cgi"
require "net/http"

module Sources
  class AllMovieGuide < Base
    def initialize
      @@allmovie = Net::HTTP.start("www.allmovie.com", 80)
    end
    
    def search(title)
      request = "/search/all/%s" % CGI.escape(title)
      response = @@allmovie.get(request, headers)
      [request, response]
    end
    
    def parse(response)
      # begin
        doc = Hpricot(response.body)
      # rescue
      #   return nil
      # end

      results = []

      (doc/"#results-table .cell a").each do |row|
        if row['href'] =~ /\/work\/(.*)$/
          results << { :type => "allmovie", :title => row.inner_text, :id => $1, :url => "http://www.allmovie.com/work/#{$1}"}
        end
      end

      results
    end
  end
end