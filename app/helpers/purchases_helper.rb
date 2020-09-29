module PurchasesHelper
  def edit_purchase(purchase)
    link_to 'Editar esta Compra Coletiva', edit_purchase_path(purchase) if current_user.account_type == 'Voluntário'
  end
end
