module PartnersHelper
  def supplier?(partner)
    partner.supplier ? 'Fornecedor' : 'Ponto de Entrega'
  end
end
