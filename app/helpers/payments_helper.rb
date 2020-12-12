module PaymentsHelper
  def payment_link(payment)
    return 'Pedido Pago' if payment.status == '3'

    link_to 'Clique Aqui para Pagar',
            pagseguros_path(payment_id: payment.id),
            method: :post,
            target: '_blank',
            rel: 'noopener'
  end

  def delete_orders(payment)
    return unless payment.orders.all? { |order| order.status == 'Processando' }

    link_to 'Apagar Pedido',
            payment_path(payment.id),
            method: :delete,
            data: { confirm: 'Tem certeza?' }
  end
end
