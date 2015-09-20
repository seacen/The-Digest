require_relative 'importer.rb'
require 'rss'
require 'open-uri'
require 'date'

# RSS Importer
class RssImporter < Importer
  def initialize(start_date, end_date)
    super
  end

  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        add_to_base(item)
      end
    end
  end
end
