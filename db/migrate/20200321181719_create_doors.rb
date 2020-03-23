class CreateDoors < ActiveRecord::Migration[6.0]
  def change
    create_table :doors do |t|
      t.string :name
      t.string :next_levels
      t.string :description
      t.string :image
      t.string :result
      t.string :requirement

      t.timestamps
    end
  end
end
