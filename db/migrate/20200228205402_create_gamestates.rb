class CreateGamestates < ActiveRecord::Migration[6.0]
  def change
    create_table :gamestates do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :hero_id

      t.timestamps
    end
  end
end
