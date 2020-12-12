class AddHiddenToPurchaseProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_products, :hidden, :boolean, default: false
  end
end
