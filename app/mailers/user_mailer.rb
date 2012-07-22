class UserMailer < ActionMailer::Base
  include ApplicationHelper
  default from: "notifications@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => game_name + " Password Reset"
  end
  
  def email_validation(user)
    @user = user
    mail :to => user.email, :subject => game_name + " Account Activation"
  end
end
