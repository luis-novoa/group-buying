module PartnersHelper
  def supplier?(partner)
    partner.supplier ? 'Fornecedor' : 'Ponto de Entrega'
  end

  # XX. XXX. XXX/XXXX-XX

  def cnpj_format(cnpj)
    cnpj = cnpj.to_s.split('')
    "#{cnpj[0...2].join}.#{cnpj[2...5].join}.#{cnpj[5...8].join}/#{cnpj[8...12].join}-#{cnpj[12...14].join}"
  end
end
