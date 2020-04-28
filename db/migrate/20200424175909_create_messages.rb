class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.text :body
      t.integer :topic_id

      t.timestamps
    end
  end
end
