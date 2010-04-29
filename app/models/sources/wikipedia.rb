require "cgi"
require "net/http"

module Sources
  class Wikipedia < Base
    def initialize
      @@wikipedia = Net::HTTP.start("en.wikipedia.org", 80)
    end

    def search(title)
      request = "/w/api.php?action=opensearch&search=%s&format=xml&limit=20" % CGI.escape(title)
      response = @@wikipedia.get(request, headers)
      [request, response]
    end
    
    def parse(response)
      results = []
      doc = Hpricot(response.body)
      (doc/:item).each do |row|
        if (row/:url).inner_text =~ /\/wiki\/(.*)/
          results << { :type => "wikipedia", :title => (row/:text).inner_text, :id => $1, :url => "http://en.wikipedia.org/wiki/#{$1}"}
        end
      end
      results
    end
  end
end