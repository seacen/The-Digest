require_relative 'opencalais_tagger.rb'
# TagOpencalaisTagger
class TagOpencalaisTagger < OpencalaisTagger

  def self.do_add(response, article)
    ActsAsTaggableOn.force_lowercase = true

    response.tags.each { |t| article.tag_list.add(t[:name]) }
  end
end
