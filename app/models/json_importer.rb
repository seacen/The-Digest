require 'open-uri'
require 'json'
require 'net/http'
require_relative 'importer.rb'
# Json Importer
class JsonImporter < Importer
  def initialize(start_date, end_date)
    super
  end

  def scrape
    puts @url
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    articles = JSON.parse(response)

    add_to_base(articles)
  end
end
