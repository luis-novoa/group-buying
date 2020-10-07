module PurchaseProductsHelper
  def order_form(product_id, orders = nil, ordered_products_ids = nil)
    return 'Faça Login para Comprar' unless current_user

    if ordered_products_ids&.include?(product_id)
      order = orders.find_by(purchase_product_id: product_id)
      button_text = 'Modificar'
    end
    # byebug
    order ||= current_user.orders.build(purchase_product_id: product_id)
    button_text ||= 'Adicionar ao Carrinho'
    render partial: 'orders/order_form', locals: { order: order, button_text: button_text }
  end
end
