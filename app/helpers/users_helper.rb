module UsersHelper
  private

  def greeting_message(user)
    return unless current_user == user

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

  def pending_users(users_list)
    return unless current_user.moderator

    tag.section(class: 'pending-users') do
      tag.h2('Usuários Pendentes') +
        tag.table do
          rows = tag.td('Nome') + tag.td('Email') + tag.td('Telefone 1') + tag.td('Tipo') + tag.td('Aprovar?')
          concat(tag.tr(rows))
          users_list.each do |user|
            user_link = link_to user.name, user_path(user)
            approval_link = link_to 'Sim', user_path(user, waiting_approval: false), method: :put
            reject_link = link_to 'Não',
                                  user_path(user, account_type: 'Comprador', waiting_approval: false), method: :put
            rows = tag.td(user_link) +
                   tag.td(user.email) +
                   tag.td("#{user.phone1} (#{user.phone1_type})") +
                   tag.td(user.account_type) +
                   tag.td(approval_link + reject_link)
            concat(tag.tr(rows))
          end
        end
    end
  end

  def adm_actions(user = nil)
    return unless current_user.super_user
    return tag.td('Ações') unless user

    links = []
    unless user.account_type == 'Voluntário'
      become_volunteer = link_to 'Tornar Voluntário', user_path(user, account_type: 'Voluntário'), method: :put
      links << become_volunteer
    end
    unless user.account_type == 'Comprador'
      become_buyer = link_to 'Tornar Comprador', user_path(user, account_type: 'Comprador'), method: :put
      links << become_buyer
    end
    # unless user.account_type == 'Ponto de Entrega'
    #   become_delivery_point = link_to 'Tornar Ponto de Entrega',
    #                                   user_path(user, account_type: 'Ponto de Entrega'), method: :put
    #   links << become_delivery_point
    # end
    if user.account_type == 'Voluntário'
      mod = if user.moderator
              link_to 'Revogar Moderador', user_path(user, moderator: false), method: :put
            else
              link_to 'Tornar Moderador', user_path(user, moderator: true), method: :put
            end
      links << mod
    end

    links = links.sum
    tag.td(links)
  end

  def mod_reveal(user = nil)
    return unless current_user.super_user
    return tag.td('Moderador?') unless user

    user.moderator ? tag.td('Sim') : tag.td('Não')
  end
end
