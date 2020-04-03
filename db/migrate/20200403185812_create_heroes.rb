class CreateHeroes < ActiveRecord::Migration[6.0]
  def change
    create_table :heroes do |t|
      t.string :name
      t.integer :exp
      t.integer :hp
      t.integer :gold
      t.string :image

      t.timestamps
    end
  end
end
