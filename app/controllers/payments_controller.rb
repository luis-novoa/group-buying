require 'httparty'

class PaymentsController < ApplicationController
  def create
    orders = current_user.orders.where(status: 'Carrinho')
    request_body = XMLUtils.create_xml(current_user, orders)
    response = HTTParty.post(request_url, headers: { 'content-type': 'application/xml' }, body: request_body)
    payment_code = XMLUtils.get_token(response.body)
    orders.update_all(payment_code: payment_code)
    byebug
    redirect_to "https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=#{payment_code}"
  end

  private

  def request_url
    email = Rails.application.credentials.pagseguro[:email]
    token = Rails.application.credentials.pagseguro[:token]
    "https://ws.sandbox.pagseguro.uol.com.br/v2/checkout?email=#{email}&token=#{token}"
  end
end
