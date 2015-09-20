require_relative 'rss_importer.rb'
require 'date'

# Billboard RSS Importer
class BbRssImporter < RssImporter
  def initialize(start_date, end_date)
    super
    # source link
    @url = 'http://www.billboard.com/articles/rss.xml'
  end

  def self.source_name
    'Billboard.com Music News'
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
                        source: Source.find_by(name: BbRssImporter.source_name),
                        summary: item.description.delete("\n"),
                        image: info[1],
                        link: item.link,
                        date_of_publication: info[0])

    add_tags(final, [item.category.content.delete(' '), 'music', 'billboard'])
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
#
# a = BbRssImporter.new(Date.today - 7, Date.today)
# a.scrape
# p a.articles
