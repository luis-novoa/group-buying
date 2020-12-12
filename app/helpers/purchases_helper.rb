module PurchasesHelper
  def edit_purchase(purchase)
    link_to 'Editar', edit_purchase_path(purchase) if current_user.account_type == 'Voluntário'
  end

  def delete_purchase_product(purchase_product)
    return unless current_user.account_type == 'Voluntário'
    return unless purchase_product.orders.empty?

    link_to 'Apagar', purchase_product_path(purchase_product), method: :delete, data: { confirm: 'Tem certeza?' }
  end

  def hide_purchase_product(purchase_product)
    return unless current_user.account_type == 'Voluntário'

    if purchase_product.hidden
      return link_to 'Revelar', purchase_product_path(purchase_product, hide: '0'), method: :put
    end

    link_to 'Esconder', purchase_product_path(purchase_product, hide: '1'), method: :put
  end
end
