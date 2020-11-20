module PaymentsHelper
  def payment_link(payment)
    return 'Pedido Pago' if payment.status == '3'

    link_to 'Clique Aqui para Pagar',
            pagseguros_path(payment_id: payment.id),
            method: :post,
            target: '_blank',
            rel: 'noopener'
  end
end
