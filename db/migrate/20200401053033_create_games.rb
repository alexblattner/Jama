class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :game_name
      t.integer :start_level_id
      t.string :description
      t.integer :admin_id
      t.string :image_url
      t.integer :popularity

      t.timestamps
    end
  end
end
