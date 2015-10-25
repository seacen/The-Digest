require_relative 'opencalais_tagger.rb'
# TopicOpencalaisTagger
class TopicOpencalaisTagger < OpencalaisTagger

  def self.do_add(response, article)
    ActsAsTaggableOn.force_lowercase = true

    response.topics.each { |t| article.tag_list.add(t[:name]) }
  end
end
