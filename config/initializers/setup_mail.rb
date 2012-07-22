ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "scottville.herokuapp.com",
  :user_name            => "dawn.of.ninjas",
  :password             => "haile440",
  :authentication       => "plain",
  :enable_starttls_auto => true
}