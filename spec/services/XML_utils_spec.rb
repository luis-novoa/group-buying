require 'rails_helper'

RSpec.describe XMLUtils, type: :feature do
  context '#create_xml' do
    let!(:user) { create(:user) }
    let!(:orders) { create_list(:order, 2, user: user) }
    it 'returns info formatted in xml' do
      output = XMLUtils.create_xml(user, user.orders)
      xml_result = "<?xml version=\"1.0\"?>\n"\
      "<checkout>\n"\
      "  <sender>\n"\
      "    <name>#{user.name}</name>\n"\
      "    <email>#{user.email}</email>\n"\
      "    <phone>\n"\
      "      <areaCode>#{user.ddd1}</areaCode>\n"\
      "      <number>#{user.phone1}</number>\n"\
      "    </phone>\n"\
      "    <documents>\n"\
      "      <document>\n"\
      "        <type>CPF</type>\n"\
      "        <value>#{user.cpf}</value>\n"\
      "      </document>\n"\
      "    </documents>\n"\
      "  </sender>\n"\
      "  <currency>BRL</currency>\n"\
      "  <items>\n"\
      "    <item>\n"\
      "      <id>#{orders[0].purchase_product.id}</id>\n"\
      "      <description>#{orders[0].purchase_product.name}</description>\n"\
      "      <amount>#{orders[0].purchase_product.price}</amount>\n"\
      "      <quantity>#{orders[0].quantity}</quantity>\n"\
      "      <weight>0</weight>\n"\
      "      <shippingCost>0.00</shippingCost>\n"\
      "    </item>\n"\
      "    <item>\n"\
      "      <id>#{orders[1].purchase_product.id}</id>\n"\
      "      <description>#{orders[1].purchase_product.name}</description>\n"\
      "      <amount>#{orders[1].purchase_product.price}</amount>\n"\
      "      <quantity>#{orders[1].quantity}</quantity>\n"\
      "      <weight>0</weight>\n"\
      "      <shippingCost>0.00</shippingCost>\n"\
      "    </item>\n"\
      "  </items>\n"\
      "  <redirectURL>https://terralimpacc.org/</redirectURL>\n"\
      "  <shipping>\n"\
      "    <addressRequired>false</addressRequired>\n"\
      "  </shipping>\n"\
      "  <timeout>100000</timeout>\n"\
      "  <maxAge>999999999</maxAge>\n"\
      "  <maxUses>999</maxUses>\n"\
      "  <receiver>\n"\
      "    <email>compracoletiva19@gmail.com</email>\n"\
      "  </receiver>\n"\
      "</checkout>\n"
      expect(output).to eq(xml_result)
    end
  end
end
