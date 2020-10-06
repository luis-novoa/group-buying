module PurchasesHelper
  def edit_purchase(purchase)
    link_to 'Editar esta Compra Coletiva', edit_purchase_path(purchase) if current_user.account_type == 'Voluntário'
  end

  def delete_purchase_product(purchase_product)
    return unless current_user.account_type == 'Voluntário'
    return unless purchase_product.orders.empty?

    link_to 'Apagar Oferta', purchase_product_path(purchase_product), method: :delete
  end
end
