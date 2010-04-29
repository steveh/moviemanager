require "cgi"
require "net/http"

module Sources
  class IMDB < Base
    def initialize
      @@imdb = Net::HTTP.start("www.imdb.com", 80)
    end

    def search(title)
      request = "/find?s=tt&q=%s" % CGI.escape(title)
      response = @@imdb.get(request, headers)
      [request, response]
    end
    
    def parse(response)
      results = []
      if response['Location'] && response['Location'] =~ /\/tt(\d+)\//
        results << { :id => $1, :url => response['Location']}
      else
        doc = Hpricot(response.body)

        (doc/"#content-2-wide #main tr td:nth-child(3)").each do |row|
          if row.inner_html =~ /\/tt(\d+)\//
            results << { :title => CGI.unescape(row.inner_text), :id => $1, :url => "http://www.imdb.com/title/#{$1}"}
          end
        end
      end
      results
    end
  end
end