class ApplicationMailer < ActionMailer::Base
  default from: ENV['SMTP_USERNAME'] || 'dabishprosenegal@gmail.com'
  layout 'mailer'
end
