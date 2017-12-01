# frozen_string_literal: true

require 'phoner'

# Validate phone numbers
class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if Phoner::Phone.valid? value, country_code: '1'
    record.errors[attribute] << (options[:message] ||
                                 'is not a valid phone number')
  end
end
