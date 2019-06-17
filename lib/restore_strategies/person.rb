# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's person
  #
  # This is not meant to be standalone functional, there's enough here for a
  # person to be an OrganizationOpportunity's coordinator
  class Person < ApiObject
    include RestoreStrategies::POSTing

    attr_accessor :given_name, :family_name, :gender, :telephone, :email

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
      end

      field_attr :id, :uuid, :given_name, :family_name, :gender, :telephone,
                 :email
    end
  end
end
