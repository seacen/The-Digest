# search engine
class SearchEngine
  def self.do_search(q)
    qarray = q.split(',')
    articles = Article.all
    weighted_articles = []

    qarray.each(&:downcase!)

    articles.each do |article|
      if (weighted_article = check_match(article, qarray))
        weighted_articles << weighted_article
      end
    end
    sort_and_clean(weighted_articles)
  end

  def self.check_match(article, qarray)
    weights = 0

    qarray.each do |key|
      key_weight = calc_weight(key, article)
      if key_weight == 0
        return nil
      else
        weights += key_weight
      end
    end
    [weights, article]
  end

  TAG_W = 4
  TITLE_W = 3
  DESC_W = 2
  SOURCE_W = 1
  def self.calc_weight(key, article)
    weight = 0

    (weight += TAG_W) if article.tag_list.include?(key)
    (weight += TITLE_W) if article.title.downcase.include?(key)
    unless article.summary.nil?
      (weight += DESC_W) if article.summary.downcase.include?(key)
    end
    (weight += SOURCE_W) if article.source.name.downcase.include?(key)

    weight
  end

  def self.sort_and_clean(weighted_articles)
    result = []

    date = Date.today
    weighted_articles.sort_by! { |a| [-a[0], date - a[1].date_of_publication] }

    weighted_articles.each do |article|
      result << article[1]
    end

    result
  end
end
