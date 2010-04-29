# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'fastercsv'

sources = ["All Movie Guide", "Amazon", "IMDB", "MetaCritic", "Fatso", "Rotten Tomatoes", "Wikipedia"]

sources.each do |source_name|
  worker_class = 'Sources::' + source_name.gsub(/[^a-z0-9_]/i, '_').camelize

  source = Source.create!(:name => source_name, :worker_class => worker_class)

  puts "#{source_name} => #{worker_class}"
end

csv = FasterCSV.new(File.open('db/seed/library.csv', 'r'), :headers => true)
csv.each do |row|
  Movie.create!(:title => row['title'])
end