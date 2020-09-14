class CustomDeviseMailer < Devise::Mailer
  protected

  def subject_for(key)
    if key.to_s == 'confirmation_instructions'
      'Ative sua conta no Terra Limpa'
    else
      super
    end
  end
end
