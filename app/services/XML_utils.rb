require 'nokogiri'

class XMLUtils
  def self.create_url_encoded(user, orders, payment_id, redirect_url, notification_url)
    output = {
      email: Rails.application.credentials.pagseguro[:email],
      token: Rails.application.credentials.pagseguro[:sandbox_token],
      currency: 'BRL',
      senderName: user.name,
      senderEmail: user.email,
      senderAreaCode: user.ddd1,
      senderPhone: user.phone1,
      senderCPF: user.cpf,
      shippingAddressRequired: 'false',
      redirectURL: redirect_url,
      notificationURL: notification_url,
      timeout: '100000',
      maxAge: '999999999',
      maxUses: '999',
      receiverEmail: Rails.application.credentials.pagseguro[:email],
      reference: "PGTO#{payment_id}"
    }
    i = 0
    orders.each do |order|
      i += 1
      output["itemId#{i}"] = order.purchase_product.id
      output["itemDescription#{i}"] = order.purchase_product.name
      output["itemAmount#{i}"] = format('%<price>.2f', price: order.purchase_product.price)
      output["itemQuantity#{i}"] = order.quantity
      output["itemWeight#{i}"] = '0'
      output["itemShippingCost#{i}"] = '0.01'
    end
    URI.encode_www_form(output)
  end

  def self.get_attr(body, attr)
    Nokogiri::XML(body).xpath("//#{attr}").text
  end
end
