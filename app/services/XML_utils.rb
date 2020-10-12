require 'nokogiri'

class XMLUtils
  def self.create_xml(user, orders)
    output = Nokogiri::XML::Builder.new do |xml|
      xml.checkout do
        xml.sender do
          xml.name user.name
          xml.email user.email
          xml.phone do
            xml.areaCode user.ddd1
            xml.number user.phone1
          end
          xml.documents do
            xml.document do
              xml.type 'CPF'
              xml.value user.cpf
            end
          end
        end
        xml.currency 'BRL'
        xml.items do
          orders.each do |order|
            xml.item do
              xml.id order.purchase_product.id
              xml.description order.purchase_product.name
              xml.amount order.purchase_product.price
              xml.quantity order.quantity
              xml.weight '0'
              xml.shippingCost '0.00'
            end
          end
        end
        xml.redirectURL 'https://terralimpacc.org/'
        xml.shipping { xml.addressRequired 'false' }
        xml.timeout '100000'
        xml.maxAge '999999999'
        xml.maxUses '999'
        xml.receiver { xml.email 'compracoletiva19@gmail.com' }
      end
    end
    output.to_xml
  end

  def self.get_token(body)
    Nokogiri::XML(body).xpath('//code').text
  end
end
