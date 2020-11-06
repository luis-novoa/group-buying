class PagseguroNotificationsController < ApplicationController
  def create
    return unless params[:notificationType] == 'transaction'

    credentials = URI.encode_www_form(
      {
        email: Rails.application.credentials.pagseguro[:email],
        token: Rails.application.credentials.pagseguro[:sandbox_token]
      }
    )
    transaction = HTTParty.get(
      "https://ws.pagseguro.uol.com.br/v3/transactions/notifications/#{params[:notificationCode]}?#{credentials}"
    )
    return unless XMLUtils.get_attr(transaction.body, 'status') == '3'

    payment = Payment.find_by(ref: XMLUtils.get_attr(transaction.body, 'reference'))
    payment.orders.each { |order| order.update(status: 'Pago') }
  end
end
