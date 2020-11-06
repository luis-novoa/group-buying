class PagseguroNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    transaction_status = XMLUtils.get_attr(transaction.body, 'status')
    return unless transaction_status == '3'

    payment = Payment.find_by(ref: XMLUtils.get_attr(transaction.body, 'reference'))
    payment.orders.each { |order| order.update(status: 'Pago') }
    payment.update(status: transaction_status, code: XMLUtils.get_attr(transaction.body, 'code'))
  end
end
