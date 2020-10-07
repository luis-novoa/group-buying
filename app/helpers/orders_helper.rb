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
end
