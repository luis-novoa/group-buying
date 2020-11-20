class ApplicationController < ActionController::Base
  before_action :check_session
  before_action :check_volunteer_info, if: -> { current_user && current_user.account_type == 'Voluntário' }

  private

  def check_session
    unauthorized(:not_logged) unless current_user
  end

  def unauthorized(message)
    messages = {
      not_logged: 'Página disponível apenas para usuários cadastrados.',
      need_approval: 'Sua conta precisa ser aprovada por um membro da equipe Terra Limpa '\
      'para que você possa acessar esta página.',
      forbidden: 'O acesso a esta página não é permitido para sua conta.'
    }
    flash[:notice] = messages[message]
    redirect_to root_path
  end

  def check_volunteer_info
    return unless current_user.volunteer_info.nil?

    flash[:alert] = 'Complete seu cadastro para prosseguir'
    redirect_to new_volunteer_info_path
  end

  def compress_image(image)
    image_optim = ImageOptim.new(
      allow_lossy: true, nice: 19, jpegoptim: { max_quality: 25 }, pngout: false, svgo: false
    )
    image_optim.optimize_image!(image.tempfile.path)
  end

  def only_volunteers
    unauthorized(:forbidden) unless current_user.account_type == 'Voluntário'
  end

  def only_approved_users
    unauthorized(:need_approval) if current_user.waiting_approval
  end

  def except_buyers
    unauthorized(:forbidden) if current_user.account_type == 'Comprador'
  end

  def suppliers_list
    partners = Partner.all.where(supplier: true)
    @partner_select = []
    partners.each do |partner|
      @partner_select.push([partner.name, partner.id])
    end
  end
end
