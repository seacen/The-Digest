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
require_relative 'taggers/noun_tagger'
require_relative 'taggers/section_tagger'
require_relative 'taggers/tag_opencalais_tagger'
require_relative 'taggers/topic_opencalais_tagger'

# importer
class Importer
  # A news scrape is initialised with the start and end date, it
  # then validates that the required methods are provided
  def initialize(start_date, end_date)
    @start = start_date
    @end = end_date
  end

  private

  def add_tags(article, section)
    SectionTagger.tag(article, section)
    NounTagger.tag(article)
    TagOpencalaisTagger.tag(article)
    TopicOpencalaisTagger.tag(article)
    article.save
  end

  # Method to return news articles, ensuring that we only return
  # unique news articles
  # def articles
  #   @articles.uniq
  # end
end
