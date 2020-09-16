class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :quantity, null: false
      t.decimal :total, null: false, precision: 8, scale: 2
      t.boolean :paid, default: false
      t.string :delivery_city, null: false
      t.references :user, null: false, foreign_key: true
      t.references :purchase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
