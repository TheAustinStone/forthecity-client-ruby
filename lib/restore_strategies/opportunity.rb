require_relative 'signup'
require_relative'error'

module RestoreStrategies
  # Objectification of the API's opportunity
  class Opportunity
    include ActiveModel::Validations
    include ActiveModel::Conversion
    include ActiveModel::Naming
    include ActiveModel::Conversion

    attr_reader :response, :client, :id, :name, :type, :featured, :description,
                :location, :items_committed, :items_given, :max_items_needed,
                :ongoing, :organization, :instructions, :gift_question, :days,
                :group_types, :issues, :regions, :supplies, :skills,
                :municipalities

    def initialize(json, response)
      @response = response.response

      json['data'].each do |datum|
        instance_variable_set("@#{datum['name'].underscore}", value_of(datum))
      end

      json['links'].each do |link|
        @signup_href = link['href'] if link['rel'] == 'signup'
      end
    end

    # For Rails API
    # http://api.rubyonrails.org/classes/ActiveModel/Model.html#method-i-persisted-3F
    def persisted?
      true
    end

    def value_of(datum)
      # rubocop:disable Style/GuardClause
      if !datum['value'].nil?
        return datum['value']
      elsif !datum['array'].nil?
        return datum['array']
      elsif !datum['object'].nil?
        return datum['object']
      end
      # rubocop:enable Style/GuardClause

      nil
    end
    private :value_of

    def self.find(id)
      raise ArgumentError, 'id must be integer' unless id.is_a? Integer

      api_response = RestoreStrategies.client.get_opportunity(id)

      case api_response.response.code.to_i
      when 200
        json = JSON.parse(api_response.data)['collection']['items'][0]
        Opportunity.new(json, api_response)
      when 404
        raise NotFoundError.new(api_response, 'Opportunity not found')
      end
    end

    def self.where(params)
      items_from_response(RestoreStrategies.client.search(params))
    end

    def self.all
      items_from_response(RestoreStrategies.client.list_opportunities)
    end

    def self.first
      all.first
    end

    def self.items_from_response(api_response)
      results = []
      items = JSON.parse(api_response.data)['collection']['items']

      items.each do |item|
        results.push(Opportunity.new(item, api_response))
      end

      results
    end
  end
end
