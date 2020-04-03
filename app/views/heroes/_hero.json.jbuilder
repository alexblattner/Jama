json.extract! hero, :id, :name, :exp, :hp, :gold, :image, :created_at, :updated_at
json.url hero_url(hero, format: :json)
