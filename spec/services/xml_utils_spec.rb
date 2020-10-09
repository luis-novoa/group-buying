# require 'rails_helper'

# RSpec.describe XMLUtils, type: :helper do
#   context '#create_xml' do
#     let(:user) { create(:user) }
#     let(:orders) { create_list(:order, 2, user: user) }
#     it 'returns info formatted in xml' do
#       output = XMLUtils.create_xml(user.orders)
#       xml_result = '<?xml version="1.0"?>'\
#       '<checkout>'\
#         '<sender>'\
#           '<name>Jose Comprador</name>'\
#           '<email>comprador@uol.com.br</email>'\
#           '<phone>'\
#             '<areaCode>99</areaCode>'\
#             '<number>999999999</number>'\
#           '</phone>'\
#           '<documents>'\
#             '<document>'\
#               '<type>CPF</type>'\
#               '<value>11475714734</value>'\
#             '</document>'\
#           '</documents>'\
#         '</sender>'\
#         '<currency>BRL</currency>'\
#         '<items>'\
#           '<item>'\
#             '<id>0001</id>'\
#             '<description>Produto PagSeguroI</description>'\
#             '<amount>99999.99</amount>'\
#             '<quantity>1</quantity>'\
#             '<weight>10</weight>'\ # always 0
#             '<shippingCost>0.00</shippingCost>'\
#           '</item>'\
#         '</items>'\
#         '<redirectURL>http://lojamodelo.com.br/return.html</redirectURL>'\
#         '<extraAmount>10.00</extraAmount>'\
#         '<reference>REF1234</reference>'\
#         '<shipping>'\
#           '<address>'\
#             '<street>Av. PagSeguro</street>'\
#             '<number>9999</number>'\
#             '<complement>99o andar</complement>'\
#             '<district>Jardim Internet</district>'\
#             '<city>Cidade Exemplo</city>'\
#             '<state>SP</state>'\
#             '<country>BRA</country>'\
#             '<postalCode>99999999</postalCode>'\
#           '</address>'\
#           '<type>1</type>'\
#           '<cost>1.00</cost>'\
#           '<addressRequired>true</addressRequired>'\
#         '</shipping>'\
#         '<timeout>25</timeout>'\
#         '<maxAge>999999999</maxAge>'\
#         '<maxUses>999</maxUses>'\
#         '<receiver>'\
#           '<email>suporte@lojamodelo.com.br</email>'\
#         '</receiver>'\
#         '<enableRecover>false</enableRecover>'\
#       '</checkout>'
#       expect(output).to eq(xml_result)
#     end
#   end
# end
