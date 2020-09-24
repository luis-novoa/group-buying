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
    flash[:alert] = messages[message]
    redirect_to root_path
  end

  def check_volunteer_info
    return unless current_user.volunteer_info.nil?

    flash[:notice] = 'Complete seu cadastro para prosseguir'
    redirect_to new_volunteer_info_path
  end

  def compress_image(image)
    image_optim = ImageOptim.new(allow_lossy: true, nice: 19, jpegoptim: { max_quality: 25 })
    image_optim.optimize_image!(image.tempfile.path)
  end
end
