require 'active_model'
require_relative 'collection_json_utils'
require_relative '../validators/phone_validator.rb'
require 'email_validator'
require 'phoner'

module RestoreStrategies
  # Signup class
  class Signup
    include ActiveModel::Validations
    include ActiveModel::Conversion
    include ActiveModel::Naming
    include RestoreStrategies::POSTing

    attr_accessor :given_name, :family_name, :telephone, :email, :comment,
                  :num_of_items_committed, :lead, :opportunity_id, :response,
                  :campus

    validates :given_name, :family_name, :opportunity_id, presence: true
    validates :email, email: true
    validates :telephone, phone: true

    def initialize(hash)
      legal_keys = %w(given_name family_name telephone email comment
                      num_of_items_committed lead campus opportunity_id)

      hash.each_pair do |key, value|
        next unless legal_keys.include?(key.to_s)

        instance_variable_set("@#{key}", value)
      end

      field_attr :given_name, :family_name, :telephone, :email, :comment,
                 :num_of_items_committed, :lead, :campus
    end

    def save
      return false unless valid?

      payload = to_payload

      @response = RestoreStrategies.client.submit_signup(
        opportunity_id,
        payload
      )

      if @response.response.code == '202'
        true
      else
        false
      end
    end
  end

  class SignupValidationError < StandardError
  end
end
