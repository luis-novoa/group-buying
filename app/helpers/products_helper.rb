module ProductsHelper
  def format_weight(weight, weight_type)
    return "#{weight}#{weight_type}" if weight < 1000

    formatted_weight = (weight.to_f / 1000)
    formatted_weight = format('%<weight>g', weight: format('%<weight>.2f', weight: formatted_weight))
    formatted_weight = formatted_weight.gsub(/\./, ',')
    return formatted_weight + 'Kg' if weight_type == 'g'

    formatted_weight + 'L'
  end
end
