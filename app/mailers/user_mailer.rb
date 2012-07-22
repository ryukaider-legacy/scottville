class UserMailer < ActionMailer::Base
  include ApplicationHelper
  default from: "dawn.of.ninjas@gmail.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => game_name + " password reset"
  end
  
  def email_validation(user)
    @user = user
    mail :to => user.email, :subject => game_name + " account activation"
  end
end
