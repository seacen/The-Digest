json.array!(@articles) do |article|
  json.extract! article, :id, :source_id, :title, :date_of_publication, :summary, :author_id, :image, :link
  json.url article_url(article, format: :json)
end
