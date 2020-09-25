class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.boolean :active, default: true
      t.string :status, limit: 25, default: 'Aberta'
      t.decimal :total, precision: 8, scale: 2, default: 0.00
      t.text :message, limit: 500, default: ''
      t.references :partner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
