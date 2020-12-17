class PagsegurosController < ApplicationController
  def create
    payment = Payment.includes(orders: :purchase_product).find(params[:payment_id])
    request_body = XMLUtils.create_url_encoded(current_user, payment.orders, payment.id)
    response = HTTParty.post(
      'https://ws.pagseguro.uol.com.br/v2/checkout',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: request_body
    )
    error = XMLUtils.get_attr(response.body, 'error')
    if error.blank?
      payment_code = XMLUtils.get_attr(response.body, 'code')
      redirect_to "https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=#{payment_code}"
    else
      render xml: response.body
    end
  end
end
