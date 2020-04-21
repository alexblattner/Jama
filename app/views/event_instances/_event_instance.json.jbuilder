json.extract! event_instance, :id, :gamestate_id, :level_id, :event_id, :progress, :created_at, :updated_at
json.url event_instance_url(event_instance, format: :json)
