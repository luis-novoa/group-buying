module OrdersHelper
  def city_options(product)
    case product.offer_city
    when 'Sinop e Cuiabá'
      [%w[Sinop Sinop], %w[Cuiabá Cuiabá]]
    when 'Sinop'
      [%w[Sinop Sinop]]
    when 'Cuiabá'
      [%w[Cuiabá Cuiabá]]
    end
  end

  def close_cart_link(orders)
    link_to 'Fechar Carrinho', payments_path, method: :post, data: { confirm: 'Tem certeza?' } unless orders.empty?
  end
end
