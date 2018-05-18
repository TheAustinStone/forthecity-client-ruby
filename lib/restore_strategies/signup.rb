# frozen_string_literal: true

require 'active_model'
require_relative 'collection_json_utils'
require_relative '../validators/phone_validator.rb'
require 'email_validator'
require 'phoner'

module RestoreStrategies
  # Signup class
  class Signup < ApiCollectable
    include RestoreStrategies::POSTing

    attr_accessor :given_name, :family_name, :telephone, :email, :comment,
                  :numOfItemsCommitted, :lead, :opportunity_id, :response,
                  :campus, :church
    attr_reader :updated_at, :created_at, :opportunity_name, :organization_name,
                :issues, :level

    validates :given_name, :family_name, :opportunity_id, presence: true
    validates :email, email: true
    validates :telephone, phone: true

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        legal_keys = %w[given_name family_name telephone email comment
                        numOfItemsCommitted lead campus church opportunity_id]

        data.each_pair do |key, value|
          next unless legal_keys.include?(key.to_s)

          instance_variable_set("@#{key}", value)
        end
        @path = "/api/admin/users/#{data[:user_id]}/signups"
      end

      field_attr :given_name, :family_name, :telephone, :email, :comment,
                 :numOfItemsCommitted, :lead, :campus, :church
    end

    def save
      return false unless valid?

      payload = to_payload

      @response = RestoreStrategies.client.post_item(
        "/api/opportunities/#{opportunity_id}/signup",
        payload
      )

      @response.response.code == '202'
    end
  end

  class SignupValidationError < StandardError
  end
end
