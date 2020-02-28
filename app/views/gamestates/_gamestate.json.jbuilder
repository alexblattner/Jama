json.extract! gamestate, :id, :user_id, :game_id, :hero_id, :created_at, :updated_at
json.url gamestate_url(gamestate, format: :json)
