class PagsegurosController < ApplicationController
  def create
    payment = Payment.includes(orders: :purchase_product).find(params[:payment_id])
    request_body = XMLUtils.create_url_encoded(current_user, payment.orders, payment.id)
    response = HTTParty.post(
      'https://ws.pagseguro.uol.com.br/v2/checkout',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded; charset=ISO-8859-1' },
      body: request_body
    )
    error = XMLUtils.get_attr(response.body, 'error')
    if error
      render xml: response.body
    else
      payment_code = XMLUtils.get_attr(response.body, 'code')
      redirect_to "https://pagseguro.uol.com.br/v2/checkout/payment.html?code=#{payment_code}"
    end
  end
end
