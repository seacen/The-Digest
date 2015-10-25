require_relative 'json_importer.rb'
require 'net/http'
require 'date'
# TheGuardian Json Importer
class TgJsonImporter < JsonImporter
  def initialize(start_date, end_date)
    super
    # source link
    base_url = 'http://content.guardianapis.com/search?'
    fromdate_q = "from-date=#{@start.strftime('%Y-%m-%d')}"
    todate_q = "&to-date=#{@end.strftime('%Y-%m-%d')}"
    sectionorder_q = '&section=australia-news&order-by=newest'
    api_q = '&api-key=q4gr8mvu6ekamy9hfnfvu74y'
    @url = base_url + fromdate_q + todate_q + sectionorder_q + api_q
  end

  def self.source_name
    'The Guardian Australia News'
  end

  private

  # add articles from response to the ariticle base in News::Article
  def add_to_base(response)
    response['response']['results'].each do |article|
      # convert string to date format to store in article class
      pub_date = Date.parse(article['webPublicationDate'][0..9])
      final = Article.new(author: nil,
                          title: article['webTitle'],
                          summary: nil,
                          image: nil,
                          date_of_publication: pub_date,
                          link: article['webUrl'],
                          source: Source.find_by(name: TgJsonImporter.source_name))
      return unless final.save
      add_tags(final, 'australia')
    end
  end
end

# a=TgJsonImporter.new(Date.today-7,Date.today)
# a.scrape
