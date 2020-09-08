class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 75
      t.text :description, null: false, limit: 500
      t.references :partner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
