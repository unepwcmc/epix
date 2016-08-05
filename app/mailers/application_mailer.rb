class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@epix.org'
  layout 'mailer'
end
