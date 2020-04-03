json.extract! event_intance, :id, :gamestate_id, :level_id, :event_id, :progress, :created_at, :updated_at
json.url event_intance_url(event_intance, format: :json)
