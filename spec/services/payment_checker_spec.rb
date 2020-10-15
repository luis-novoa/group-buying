# require 'rails_helper'
# require 'httparty'
# require 'json'

# RSpec.describe 'PaymentChecker', type: :feature do
#   let(:user) { create(:user, cpf: 43_351_752_210, email: 'something@sandbox.pagseguro.com.br') }
#   let(:order) { create(:order, user: user) }
#   let(:request_body) { XMLUtils.create_xml(user, [order]) }
#   let(:email) { Rails.application.credentials.pagseguro[:email] }
#   let(:token) { Rails.application.credentials.pagseguro[:sandbox_token] }
#   let(:request_url) { "https://ws.sandbox.pagseguro.uol.com.br/v2/checkout?email=#{email}&token=#{token}" }
#   let(:response) { HTTParty.post(request_url, headers: { 'content-type': 'application/xml' }, body: request_body) }
#   let(:payment_code) { XMLUtils.get_token(response.body) }
#   let(:time) { Time.current }
#   let(:header) do
#     {
#       "Content-Type": 'application/json',
#       "Authorization": "Bearer {#{token}}"
#     }
#   end
#   let(:body) do
#     {
#       "status_to": '3'
#     }.to_json
#   end
#   it 'updates the order status if the payment was confirmed' do
#     res = HTTParty.patch(
#       "https://sandbox.api.pagseguro.com/digital-payments/v1/transactions/#{payment_code}/status",
#       headers: header,
#       body: body
#     )
#     byebug
#     travel_to time.advance(hours: 1).beginning_of_hour
#     expect(order.reload.status).to eq('Pago')
#   end
# end
