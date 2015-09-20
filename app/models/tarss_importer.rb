require_relative 'rss_importer.rb'
require 'date'

# The Age RSS Importer
class TaRssImporter < RssImporter
  def initialize(start_date, end_date)
    super
    # source link
    @url = 'http://www.theage.com.au/rssheadlines/world/article/rss.xml'
  end

  def self.source_name
    'The Age World News'
  end

  private

  # add a single article to the ariticle base in News::Article
  def add_to_base(item)
    info = validate_article(item)

    return unless info

    final = Article.new(author: nil,
                        title: item.title.delete("\n"),
                        source: Source.find_by(name: TaRssImporter.source_name),
                        summary: info[1],
                        image: nil,
                        link: item.link, date_of_publication: info[0])
    add_tags(final, 'world')
  end

  # validate if the given item is a valid article based on the date constraint
  # also remove redundant html tags appeared regularly in this rss source
  def validate_article(item)
    date = item.pubDate.to_date

    return false if @start > date || @end < date
    # remove redundant tags
    if (m = item.description.match(%r{(.)*(<p>.*<\/p>)(.*)}))
      des = m[3].delete("\n")
    else
      des = item.description.delete("\n")
    end

    [date, des]
  end
end
