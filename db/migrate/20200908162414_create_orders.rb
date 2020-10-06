class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :quantity, null: false
      t.decimal :total, null: false, precision: 8, scale: 2
      t.string :status, default: 'Carrinho'
      t.string :delivery_city, null: false
      t.string :payment_code
      t.references :user, null: false, foreign_key: true
      t.references :purchase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
