class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SENDER_ADDRESS')
  layout 'mailer'
end
