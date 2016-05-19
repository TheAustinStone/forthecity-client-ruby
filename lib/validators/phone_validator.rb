require 'phoner'

# Validate phone numbers
class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Phoner::Phone.valid? value, country_code: '1'
      record.errors[attribute] << (options[:message] ||
                                   'is not a valid phone number')
    end
  end
end
