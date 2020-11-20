module PurchaseProductsHelper
  def order_form(product, orders = nil, ordered_products_ids = nil)
    return tag.span('Faça Login para Comprar') unless current_user

    if ordered_products_ids&.include?(product.id)
      order = orders.find_by(purchase_product_id: product.id)
      button_text = 'Modificar' if order.status == 'Carrinho'
    end
    return 'Processando Pedido' if order&.status == 'Processando'

    order ||= current_user.orders.build(purchase_product_id: product.id)
    button_text ||= 'Adicionar ao Carrinho'
    render partial: 'orders/order_form', locals: { order: order, button_text: button_text, product: product }
  end
end
