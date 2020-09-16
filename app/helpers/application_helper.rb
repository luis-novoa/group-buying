module ApplicationHelper
  def error_messages
    return if flash[:alert].nil?

    errors = tag.ul do
      flash[:alert].each do |alert|
        concat(tag.li(alert))
      end
    end
    tag.div(errors, class: %w[notification alert-danger])
  end

  def mutable_links
    current_user ? logged_in_links : logged_out_links
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
    cart_link = link_to 'Carrinho', cart_path
    cart = tag.span(cart_link, class: 'cart')
    account_link = link_to 'Minha Conta', user_path(current_user)
    account = tag.span(account_link, class: 'account')
    log_out_link = link_to 'Sair', destroy_user_session_path, method: :delete
    log_out = tag.span(log_out_link, class: 'log-out')
    cart + account + log_out
  end
end
