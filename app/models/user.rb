# update this by running:
# $ bundle exec annotate --position before

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base

  attr_accessible :email, :name, :password, :password_confirmation
  HUMANIZED_ATTRIBUTES = {
    :name => "Username",
    :password_digest => "Password"
  }
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  has_one :building, dependent: :destroy
  
  before_save { |user| user.email = email.downcase }
  before_save { |user| user.name = name.downcase }
  before_save :create_remember_token
  
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

  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
