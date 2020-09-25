class ChangeOrderAssociation < ActiveRecord::Migration[6.0]
  def change
    remove_reference :orders, :purchase, foreign_key: true
    add_reference :orders, :purchase_product, foreign_key: true
  end
end
