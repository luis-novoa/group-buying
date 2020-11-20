class CreatePurchaseProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_products do |t|
      t.string :name, null: false, limit: 75
      t.decimal :price, null: false, precision: 8, scale: 2
      t.integer :quantity, default: 99999
      t.string :offer_city, default: 'Sinop e Cuiabá'
      t.references :purchase, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
