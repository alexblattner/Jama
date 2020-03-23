class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :starting_level_id
      t.boolean :published
      t.integer :admin_id

      t.timestamps
    end
  end
end
