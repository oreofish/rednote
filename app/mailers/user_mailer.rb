class UserMailer < ActionMailer::Base
  default from: "jianxing@redflag-linux.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify.subject
  #
  def notify(email, subject, body)
    mail( to: email, subject: subject ) do |format|
      format.text { render :text => body }
    end
  end
end
