require_relative 'json_importer.rb'
require 'net/http'
require 'date'
# The New York Times Json Importer
class TnJsonImporter < JsonImporter
  def initialize(start_date, end_date)
    super
    # source link
    base_url = 'http://api.nytimes.com/svc/topstories/v1/'
    sectiontype_q = 'technology.json'
    api_q = '?api-key=06086017eca8a65803b63b67c0ecc846:0:72698771'
    @url = base_url + sectiontype_q + api_q
  end

  def self.source_name
    'The New York Times Technology Top Stories'
  end

  private

  # add articles from response to the ariticle base in News::Article
  def add_to_base(response)
    response['results'].each do |article|
      # convert string to date format to store in article class
      pub_date = Date.parse(article['published_date'][0..9])
      if article['multimedia'][1].nil?
        image = nil
      else
        image = article['multimedia'][1]['url']
      end
      final = Article.new(author: nil,
                          title: article['title'],
                          summary: article['abstract'],
                          image: image,
                          date_of_publication: pub_date,
                          link: article['url'],
                          source: Source.find_by(name: TnJsonImporter.source_name))
      next unless final.save
      add_tags(final, 'technology')
    end
  end
end

# a=TgJsonImporter.new(Date.today-7,Date.today)
# a.scrape
