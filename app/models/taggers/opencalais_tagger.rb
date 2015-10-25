# OpencalaisTagger
class OpencalaisTagger
  API_KEY = 'VYbAqLlukqvvL0PqQW7kzYtR3gRe1hnO'

  def self.tag(article)
    return if article.summary.nil?

    summary = article.summary
    oc = OpenCalais::Client.new(api_key: API_KEY)
    oc_response = oc.enrich summary

    do_add(oc_response, article)
  end
end
