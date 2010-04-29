require "cgi"
require "net/http"
require "uri"

module Sources
  class Fatso < Base
    def initialize
      @@fatso = Net::HTTP.start("www.fatso.co.nz", 80)
    end

    def search(title)
      request = "/search?q=%s&limit=30&ajax=1" % CGI.escape(title)
      response = @@fatso.get(request, headers)
      [request, response]
    end
    
    def parse(response)
      json = JSON.parse(response.body)
      
      results = []
      json.each do |row|
        row['items'].each do |item|
          uri = URI.parse('http://www.fatso.co.nz'+item['href'])
          query = CGI.parse(uri.query)
          redirect = query['redirect']
          
          if redirect.to_s =~ /\/(library|search)\?((mid|cst)\=\d+)\&aid\=103/
            results << { :title => item['name'], :url => redirect, :id => $2 }
          end
        end
      end
      results
    end
  end
end