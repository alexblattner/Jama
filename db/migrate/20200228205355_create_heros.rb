class CreateHeros < ActiveRecord::Migration[6.0]
  def change
    create_table :heros do |t|
      t.string :name
      t.integer :hero_exp
      t.integer :hero_hp

      t.timestamps
    end
  end
end
