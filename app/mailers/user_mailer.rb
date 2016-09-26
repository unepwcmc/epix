class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def default_url_options
    {
      host: Rails.application.secrets.mailer['host']
    }
  end

  def confirmation_instructions(user, token, opts={})
    opts[:subject] = 'Welcome to EPIX'
    super
  end
end
