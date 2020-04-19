json.extract! game, :id, :game_name, :start_level_id, :description, :admin_id, :image_url, :popularity, :created_at, :updated_at
json.url game_url(game, format: :json)
