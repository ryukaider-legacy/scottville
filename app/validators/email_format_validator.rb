class EmailFormatValidator < ActiveModel::EachValidator

  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  BLACKLIST_CHARACTERS = /[\"\(\)\,\:\;\<\>\[\]\\]/

  def validate_each(object, attribute, value)  
  
    unless value =~ VALID_EMAIL_REGEX
      object.errors[attribute] << (options[:message] || "is not formatted properly (must be of the form name@foo.bar)")
    end
    if value =~ BLACKLIST_CHARACTERS
      object.errors[attribute] << (options[:message] || "contains invalid characters")
    end
  end
end