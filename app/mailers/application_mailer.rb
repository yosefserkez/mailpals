class ApplicationMailer < ActionMailer::Base
  default from: "MailPals <mail@mail.mailpals.net>"
  layout "mailer"

  helper MailerHelper
end
