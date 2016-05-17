require 'active_model'
require_relative 'collection+json_utils'
require_relative '../validators/phone_validator.rb'
require 'email_validator'
require 'phoner'

module RestoreStrategiesClient

  class Signup
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Conversion
    include RestoreStrategiesClient::POSTing

    attr_reader :raw, :client, :opportunity, :id

    attr_accessor :given_name, :family_name, :telephone, :email, :comment,
                  :num_of_items_commited, :lead
    validates_length_of :given_name, {minimum: 2}
    validates_length_of :given_name, {minimum: 2}
    validates :email, :email => true
    validates :telephone, :phone => true

    #field_attr :given_name, :family_name, :telephone, :email, :comment,
    #              :num_of_items_commited, :lead

    def initialize(json_str, opportunity, client, id)
      @raw = json_str
      @opportunity = opportunity
      @client = client
      @id = id
      field_attr :given_name, :family_name, :telephone, :email, :comment,
                    :num_of_items_commited, :lead
    end
  end

  class SignupValidationError < StandardError
  end
end
