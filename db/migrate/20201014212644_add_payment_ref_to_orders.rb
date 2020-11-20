class AddPaymentRefToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :payment, foreign_key: true
    add_reference :payments, :user, foreign_key: true
  end
end
