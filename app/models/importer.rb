# This class forms the basis for a generic importer that you will write
# by extending this class and implementing the required methods. It provides
# an array data structure to store news items, methods to access these required
# by the exporter
#
# Author::    Mathew Blair (mathew.blair@unimelb.edu.au)
# Copyright:: Copyright (c) 2015 The University Of Melbourne
#
# You are required to create subclasses of this class and in those
# classes you are required to create the methods scrape and file_name
#


class Importer
  # A news scrape is initialised with the start and end date, it
  # then validates that the required methods are provided
  def initialize start_date, end_date
    @start = start_date
    @end = end_date
  end

  private

  def add_tags(article, section)
    ActsAsTaggableOn.force_lowercase = true
    if section.class == String
      article.tag_list.add(section)
    else
      section.each { |sec| article.tag_list.add(sec) }
    end
    tgr = EngTagger.new
    tagged = tgr.add_tags(article.title)
    nouns = tgr.get_nouns(tagged).keys
    nouns.each { |noun| article.tag_list.add(noun) }
    article.save
  end

  # Method to return news articles, ensuring that we only return
  # unique news articles
  # def articles
  #   @articles.uniq
  # end
end
