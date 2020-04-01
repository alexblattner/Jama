class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :level_id
      t.string :result
      t.string :description
      t.string :event_type
      t.string :image
      t.string :progress

      t.timestamps
    end
  end
end
