class CreateHeroes < ActiveRecord::Migration[6.0]
  def change
    create_table :heroes do |t|
      t.string :name
      t.integer :hero_exp
      t.integer :hero_hp
      t.integer :gold
      t.string :description

      t.timestamps
    end
  end
end
