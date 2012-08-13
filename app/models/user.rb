# update this by running:
# $ bundle exec annotate --position before

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  email_validation_token :string(255)
#  email_validation       :boolean
#

class User < ActiveRecord::Base

  attr_accessible :email, :name, :password, :password_confirmation, :email_validation
  HUMANIZED_ATTRIBUTES = {
    :name => "Username",
    :password_digest => "Password",
    :email => "Email Address"
  }
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  has_one :building, dependent: :destroy
  
  before_save { |user| user.email = email.downcase }
  # before_save { |user| user.name = name.downcase }
  before_create { generate_token(:remember_token) }

  validates :name,  presence:     true,
                    length:       { maximum: 20 },
                    uniqueness:   { case_sensitive: false },
                    name_format:  true, # see app/validations/name_format_validator.rb
                    reduce:       true  # only show the first error
  
  validates :email, presence:     true,
                    length:       { maximum: 254 },
                    uniqueness:   { case_sensitive: false },
                    email_format: true, # see app/validators/email_format_validator.rb
                    reduce:       true  # only show the first error
                    
  has_secure_password   # putting this here makes the errors appear in the right order

  validates :password,  length:   { :in => 6..20 },
                        presence: true,
                        reduce:   true

  validates :password_confirmation, presence:   true
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end
  
  def send_email_validation
    unless self.email_validation
      generate_token(:email_validation_token)
      save!(validate: false)
      UserMailer.email_validation(self).deliver
    end
  end

  private
  
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end  
end
