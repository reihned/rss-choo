json.array!(@filters) do |filter|
  json.extract! filter, :id, :feed_url, :keywords
  json.url filter_url(filter, format: :json)
end
