class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 75
      t.integer :weight, null: false
      t.string :weight_type, null: false
      t.text :description, null: false, limit: 5000
      t.decimal :last_price, default: 0, precision: 8, scale: 2
      t.integer :last_quantity, default: 0
      t.references :partner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
