require 'httparty'

class PaymentsController < ApplicationController
  def create
    new_payment = Payment.new
    new_payment.save
    orders = current_user.orders.where(status: 'Carrinho')
    request_body = XMLUtils.create_url_encoded(current_user, orders, new_payment.id)
    response = HTTParty.post(
      'https://ws.sandbox.pagseguro.uol.com.br/v2/checkout',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded; charset=ISO-8859-1' },
      body: request_body
    )
    payment_code = XMLUtils.get_attr(response.body, 'code')
    redirect_to "https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=#{payment_code}"
    orders.update_all(status: 'Processando', payment_id: new_payment.id)
    new_payment.update(ref: "PGTO#{new_payment.id}", code: payment_code)
  end
end
