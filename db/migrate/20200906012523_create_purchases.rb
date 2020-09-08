class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.decimal :price, null: false, precision: 8, scale: 2
      t.boolean :limited_quantity, default: false
      t.integer :quantity, default: 0
      t.boolean :active, default: true
      t.string :status, limit: 25, default: 'Aberta'
      t.decimal :total, precision: 8, scale: 2, default: 0.00
      t.text :message, limit: 500, default: ''
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
