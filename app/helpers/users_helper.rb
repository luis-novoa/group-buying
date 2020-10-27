module UsersHelper
  def volunteer_info(user)
    return unless user.account_type == 'Voluntário'

    render partial: 'volunteer_infos/infos', locals: { infos: user.volunteer_info }
  end

  def user_tools
    return if current_user.account_type == 'Comprador'

    render partial: 'users/delivery_point_tools'
  end

  def purchases_link
    return unless current_user.id == params[:id].to_i

    tag.div(class: 'separator') + tag.span(link_to('Pedidos Prontos para Entrega', purchase_lists_path))
  end

  private

  def pending_users(users_list)
    return unless current_user.moderator

    tag.article(class: 'table') do
      tag.h2('Usuários Pendentes') +
        tag.table do
          rows = tag.td('Nome') + tag.td('Email') + tag.td('Telefone') + tag.td('Aprovar?')
          concat(tag.tr(rows))
          users_list.each do |user|
            user_link = link_to user.name, user_path(user)
            approval_link = link_to 'Sim', user_path(user, waiting_approval: false), method: :put
            reject_link = link_to 'Não',
                                  user_path(user, account_type: 'Comprador', waiting_approval: false), method: :put
            rows = tag.td(user_link) +
                   tag.td(user.email) +
                   tag.td("#{phone_format(user.ddd1, user.phone1)} (#{user.phone1_type})") +
                   tag.td(approval_link + reject_link, class: 'user-approval')
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

  def volunteer_actions(new_purchase, partner_select)
    return unless current_user.account_type == 'Voluntário' && current_user.id == params[:id].to_i

    render partial: 'users/volunteer_tools', locals: { template: new_purchase, options: partner_select }
  end
end
