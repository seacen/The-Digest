# SectionTagger
class SectionTagger
  ActsAsTaggableOn.force_lowercase = true

  def self.tag(article, section)
    if section.class == String
      article.tag_list.add(section)
    else
      section.each { |sec| article.tag_list.add(sec) }
    end
  end
end
