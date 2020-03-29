class CreateLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.string :name
      t.string :event_id
      t.string :doors
      t.string :description
      t.string :image
      t.string :game_id
      t.integer :prev_level_id

      t.timestamps
    end
  end
end
