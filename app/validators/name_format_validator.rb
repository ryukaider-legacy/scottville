class NameFormatValidator < ActiveModel::EachValidator

  VALID_USERNAME_REGEX = /\A[\w]+\z/i

  def validate_each(object, attribute, value)  
  
    unless value =~ VALID_USERNAME_REGEX
      object.errors[attribute] << (options[:message] || "can only contain letters, numbers, and underscores")
    end
  end
end