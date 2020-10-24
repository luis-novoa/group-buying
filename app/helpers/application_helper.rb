module ApplicationHelper
  def error_messages
    return if flash[:alert].nil?

    errors = [flash[:alert]] unless flash[:alert].respond_to?(:each)
    errors ||= flash[:alert]
    render partial: 'layouts/errors', locals: { errors: errors }
  end

  def mutable_links
    current_user ? logged_in_links : logged_out_links
  end

  def display_notice
    return if flash[:notice].nil?

    render partial: 'layouts/notice', locals: { notice: flash[:notice] }
  end

  private

  def logged_out_links
    sign_up_link = link_to 'Cadastre-se', new_user_registration_path
    sign_up = tag.span(sign_up_link, class: 'sign-up')
    log_in_link = link_to 'Acesse sua Conta', new_user_session_path
    log_in = tag.span(log_in_link, class: 'log-in')
    sign_up + log_in
  end

  def logged_in_links
    cart_link = link_to 'Carrinho', orders_path
    cart = tag.span(cart_link, class: 'cart')
    account_link = link_to 'Minha Conta', user_path(current_user)
    account = tag.span(account_link, class: 'account')
    log_out_link = link_to 'Sair', destroy_user_session_path, method: :delete
    log_out = tag.span(log_out_link, class: 'log-out')
    cart + account + log_out
  end

  def phone2(object)
    tag.li("Telefone Adicional: #{object.phone2} (#{object.phone2_type})") if object.phone2
  end

  def br_currency(number)
    number_to_currency(number, unit: '', separator: ',', delimiter: '', precision: 2)
  end
end
