require_relative 'signup'
require_relative'error'

module RestoreStrategies
  # Objectification of the API's opportunity
  class Opportunity
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Conversion

    attr_reader :raw, :client, :id, :name, :type, :featured, :description,
                :location, :items_committed, :items_given, :max_items_needed,
                :ongoing, :organization, :instructions, :gift_question, :days,
                :group_type, :issues, :region, :supplies, :skills

    def initialize(json_obj, json_str)
      @raw = json_str
      # TODO: Find a better way of capturing the ID
      @id = json_obj['href'][%r{[^(\/api\/opportunities\/)].}].to_i

      json_obj['data'].each do |datum|
        instance_variable_set("@#{datum['name'].underscore}", datum['value'])
      end

      json_obj['links'].each do |link|
        @signup_href = link['href'] if link['rel'] == 'signup'
      end
    end

    def self.find(id)
      raise ArgumentError, 'id must be integer' unless id.is_a? Integer

      api_response = RestoreStrategies.client.get_opportunity(id)

      case api_response.response.code.to_i
      when 200
        json = JSON.parse(api_response.data)['collection']['items'][0]
        Opportunity.new(json, api_response.data)
      when 404
        raise NotFoundError.new(api_response, 'Opportunity not found')
      end
    end

    def create_signup
      signup_str = RestoreStrategies.client.get_signup id
      RestoreStrategies::Signup.new(signup_str, self, client, id)
    end

    def submit_signup(signup)
      raise TypeError unless signup.is_a? Signup
      raise SignupValidationError,
            'Signup does not contain valid data' unless signup.valid?
      RestoreStrategies.client.submit_signup(id, signup.to_payload)
    end
  end
end
