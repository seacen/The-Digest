require_relative 'rss_importer.rb'
require 'date'

# The Economist RSS Importer
class TeRssImporter < RssImporter
  def initialize(start_date, end_date)
    super
    # source link
    @url = 'http://www.economist.com/sections/business-finance/rss.xml'
  end

  def self.source_name
    'The Economist Business News'
  end

  private

  # add a single article to the ariticle base in News::Article
  def add_to_base(item)
    info = validate_article(item)

    return unless info

    arti_author = item.author.delete("\n")
    unless add_author = Author.find_by(name: arti_author)
      add_author = Author.create(name: arti_author)
    end
    final = Article.new(author: add_author,
                        title: item.title.delete("\n"),
                        source: Source.find_by(name: TeRssImporter.source_name),
                        summary: info[1],
                        image: nil,
                        link: item.link,
                        date_of_publication: info[0])

    add_tags(final, %w(business finance economist))
  end

  # validate if the given item is a valid article based on the date constraint
  # also remove redundant html tags appeared regularly in this rss source
  def validate_article(item)
    date = item.pubDate.to_date

    return false if @start > date || @end < date
    # remove redundant tags
    san = Rails::Html::FullSanitizer.new
    des = san.sanitize(item.description).delete("\n")

    [date, des]
  end
end
