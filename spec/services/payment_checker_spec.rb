# require 'rails_helper'
# require 'httparty'
# require 'json'

# RSpec.describe 'PaymentChecker', type: :feature, js: true do
#   # c72898760549088852930
#   let(:user) { create(:user, cpf: 43_351_752_210, email: 'test@sandbox.pagseguro.com.br', phone1: '998765432') }
#   let!(:order) { create(:order, user: user) }
#   let(:email) { Rails.application.credentials.pagseguro[:email] }
#   let(:token) { Rails.application.credentials.pagseguro[:sandbox_token] }
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
#     login(user)
#     click_on 'Carrinho'
#     click_on 'Fechar Carrinho'
#     # fill_in 'senderPassword', with: 'vJdJmudwnD308egJ'
#     # click_on 'Avançar'
#     fill_in 'creditCardNumber', with: '4111111111111111'
#     sleep(2)
#     fill_in 'creditCardCVV', with: '123'
#     fill_in 'creditCardDueDate_Month', with: '12'
#     fill_in 'creditCardDueDate_Year', with: '30'
#     sleep(2)
#     find("option[value='1']").click
#     fill_in 'creditCardHolderName', with: user.name
#     fill_in 'holderCPF', with: user.cpf
#     fill_in 'holderAreaCode', with: user.ddd1
#     fill_in 'holderPhone', with: user.phone1
#     fill_in 'holderBornDate', with: '01/01/1980'
#     fill_in 'cardBillingAddressPostalCode', with: '78525000'
#     fill_in 'cardBillingAddressStreet', with: 'rua teste'
#     fill_in 'billingAddressNumber', with: '23'
#     fill_in 'billingAddressDistrict', with: 'teste'
#     click_on 'Confirmar o pagamento'
#     sleep(20)
#     payment = Payment.all.first
#     payment_info = HTTParty.get(
#       'https://ws.sandbox.pagseguro.uol.com.br/'\
#       "v2/transactions?email=#{email}&token=#{token}"\
#       "&reference=#{payment.ref}"
#     )
#     payment_token = XMLUtils.get_attr(payment_info.body, 'code').gsub(/-/, '')
#     res = HTTParty.patch(
#       "https://sandbox.api.pagseguro.com/digital-payments/v1/transactions/#{payment_token}/status",
#       headers: header,
#       body: body
#     )
#     byebug
#     travel_to time.advance(hours: 1).beginning_of_hour
#     sleep(5)
#     expect(order.reload.status).to eq('Pago')
#   end
# end

# HTTParty.get("https://ws.sandbox.pagseguro.uol.com.br/v2/transactions?email=#{email}&token=#{token}&reference=#{payment.ref}")
# HTTParty.patch("https://sandbox.api.pagseguro.com/digital-payments/v1/transactions/#{payment_token}/status", headers: header, body: body)
