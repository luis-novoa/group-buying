require 'httparty'

class PaymentsController < ApplicationController
  def create
    new_payment = Payment.new
    new_payment.save
    orders = current_user.orders.where(status: 'Carrinho')
    request_body = XMLUtils.create_xml(current_user, orders, new_payment.id)
    response = HTTParty.post(request_url, headers: { 'content-type': 'application/xml' }, body: request_body)
    payment_code = XMLUtils.get_attr(response.body, 'code')
    redirect_to "https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=#{payment_code}"
    orders.update_all(status: 'Processando', payment_id: new_payment.id)
    new_payment.update(ref: "PGTO#{new_payment.id}", code: payment_code)
  end

  private

  def request_url
    email = Rails.application.credentials.pagseguro[:email]
    token = Rails.application.credentials.pagseguro[:sandbox_token]
    "https://ws.sandbox.pagseguro.uol.com.br/v2/checkout?email=#{email}&token=#{token}"
  end
end
