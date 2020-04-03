json.extract! event, :id, :name, :result, :description, :event_type, :image, :created_at, :updated_at
json.url event_url(event, format: :json)
