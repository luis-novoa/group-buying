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

  def sum_orders(purchase_product)
    qtd_sinop = 0
    qtd_cuiaba = 0
    qtd_boleto = 0
    qtd_total = 0
    total = 0
    purchase_product.orders.each do |order|
      next if %w[Carrinho Processando Cancelado].include?(order.status)

      qtd_sinop += order.quantity if order.delivery_city == 'Sinop'
      qtd_cuiaba += order.quantity if order.delivery_city == 'Cuiabá'
      qtd_boleto += order.quantity if order.status == 'Aguardando'
      qtd_total += order.quantity
      total += order.total
    end
    total = 'R$ ' + br_currency(total)
    tag.td(total) + tag.td(qtd_sinop) + tag.td(qtd_cuiaba) + tag.td(qtd_total) + tag.td(qtd_boleto)
  end
end
