class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :code
      t.string :ref
      t.string :payment_link
      t.string :status

      t.timestamps
    end
  end
end
