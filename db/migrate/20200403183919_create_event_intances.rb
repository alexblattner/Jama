class CreateEventIntances < ActiveRecord::Migration[6.0]
  def change
    create_table :event_intances do |t|
      t.integer :gamestate_id
      t.integer :level_id
      t.integer :event_id
      t.string :progress

      t.timestamps
    end
  end
end
