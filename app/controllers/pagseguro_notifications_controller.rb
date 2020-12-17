class PagseguroNotificationsController < ActionController::API
  def create
    headers['Access-Control-Allow-Origin'] = 'https://sandbox.pagseguro.uol.com.br'
    return unless params[:notificationType] == 'transaction'

    credentials = URI.encode_www_form(
      {
        email: Rails.application.credentials.pagseguro[:email],
        token: Rails.application.credentials.pagseguro[:sandbox_token]
      }
    )
    transaction = HTTParty.get(
      "https://ws.sandbox.pagseguro.uol.com.br/v3/transactions/notifications/#{params[:notificationCode]}?#{credentials}"
    )
    transaction_status = XMLUtils.get_attr(transaction.body, 'status')
    payment = Payment.find_by(ref: XMLUtils.get_attr(transaction.body, 'reference'))
    payment.update(status: transaction_status, code: XMLUtils.get_attr(transaction.body, 'code'))
    payment.orders.each { |order| order.update(status: 'Aguardando') } if transaction_status == '1'
    payment.orders.each { |order| order.update(status: 'Pago') } if transaction_status == '3'
    payment.orders.each { |order| order.update(status: 'Cancelado') } if transaction_status == '7'
  end
end
