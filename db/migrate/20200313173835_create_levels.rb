class CreateLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.string :description
      t.string :next_levels

      t.timestamps
    end
  end
end
