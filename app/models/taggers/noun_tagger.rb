# NounTagger
class NounTagger
  def self.tag(article)
    ActsAsTaggableOn.force_lowercase = true

    tgr = EngTagger.new
    tagged = tgr.add_tags(article.title)
    nouns = tgr.get_nouns(tagged).keys
    nouns.each { |noun| article.tag_list.add(noun) }
  end
end
