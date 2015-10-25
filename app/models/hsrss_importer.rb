require_relative 'rss_importer.rb'
require 'date'

# HeraldSun RSS Importer
class HsRssImporter < RssImporter
  def initialize(start_date, end_date)
    super
    # source link
    @url = 'http://feeds.news.com.au/heraldsun/rss/heraldsun_news_breakingnews_2800.xml'
  end

  def self.source_name
    'Herald Sun Breaking News'
  end

  private

  # add a single article to the ariticle base in News::Article
  def add_to_base(item)
    info = validate_article(item)

    return unless info
    arti_author = item.source.content.delete("\n")
    unless add_author = Author.find_by(name: arti_author)
      add_author = Author.create(name: arti_author)
    end
    final = Article.new(author: add_author,
                        title: item.title.delete("\n"),
                        source: Source.find_by(name: HsRssImporter.source_name),
                        summary: item.description.delete("\n"),
                        image: info[1],
                        link: item.link,
                        date_of_publication: info[0])
    return unless final.save
    add_tags(final, 'breaking')
  end

  # validate if the given item is a valid article based on the date constraint
  # also check if an image is present in the source given
  def validate_article(item)
    date = item.pubDate.to_date
    return false if @start > date || @end < date

    if item.enclosure
      image = item.enclosure.url
    else
      image = nil
    end

    [date, image]
  end
end
