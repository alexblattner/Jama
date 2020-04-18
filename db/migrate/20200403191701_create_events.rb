class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :result
      t.string :description
      t.string :event_type
      t.string :image
      t.string :game_id
      
      t.timestamps
    end
  end
end
