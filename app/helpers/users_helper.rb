module UsersHelper
  private

  def greeting_message(user)
    case user.account_type
    when 'Comprador'
      message = 'Nesta área, você pode consultar detalhes sobre todas as suas compras e gerenciar seus dados.'
      type = 'buyer-greeting'
    when 'Voluntário'
      message = 'Nesta área, você pode consultar detalhes sobre todas as suas compras, gerenciar seus dados, '\
      'bem como realizar as atividades do Terra Limpa, como gerenciar parceiros, produtos e compras '\
      'coletivas.'
      type = 'volunteer-greeting'
    when 'Ponto de Entrega'
      message = 'Nesta área, você pode consultar detalhes sobre todas as suas compras, gerenciar seus dados '\
      'e de sua empresa (caso a tenha cadastrado aqui), e também conferir a lista de compradores '\
      'em cada compra coletiva.'
      type = 'delivery-point-greeting'
    end
    tag.span(message, class: type)
  end

  def link_to_users_index
    return if current_user.account_type == 'Comprador'

    tag.span(link_to('Todos os Usuários', users_path), class: 'users_index')
  end

  def phone2(user)
    tag.li("Telefone 2: #{user.phone2} - #{user.phone2_type}") if user.phone2
  end

  def pending_users(c_user, users_list)
    return unless c_user.moderator

    tag.section(class: 'pending-users') do
      tag.table do
        users_list.each do |user|
          tag.tr do
            tag.td(user.name) +
              tag.td(user.email) +
              tag.td("#{user.phone1} (#{user.phone1_type})")
          end
        end
      end
    end
  end
end
