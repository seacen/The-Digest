require_relative 'rss_importer.rb'
require 'date'

# BBC RSS Importer
class BbcRssImporter < RssImporter
  def initialize(start_date, end_date)
    super
    # source link
    @url = 'http://feeds.bbci.co.uk/news/politics/rss.xml'
  end

  def self.source_name
    'BBC Politics News'
  end

  private

  # add a single article to the ariticle base in News::Article
  def add_to_base(item)
    info = validate_article(item)

    return unless info

    final = Article.new(author: nil,
                        title: item.title.delete("\n"),
                        source: Source.find_by(name: BbcRssImporter.source_name),
                        summary: item.description.delete("\n"),
                        image: nil,
                        link: item.link,
                        date_of_publication: info[0])

    return unless final.save
    add_tags(final, %w(politics bbc))
  end

  # validate if the given item is a valid article based on the date constraint
  # also check if an image is present in the source given
  def validate_article(item)
    date = item.pubDate.to_date
    return false if @start > date || @end < date

    [date]
  end
end
