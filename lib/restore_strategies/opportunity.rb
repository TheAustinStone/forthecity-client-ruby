# frozen_string_literal: true

require_relative 'signup'
require 'json'

module RestoreStrategies
  # Objectification of the API's opportunity
  class Opportunity < ApiObject
    attr_reader :name, :type, :featured, :description, :location,
                :items_committed, :items_given, :max_items_needed, :ongoing,
                :organization, :instructions, :gift_question, :days,
                :group_types, :issues, :regions, :supplies, :skills,
                :municipalities, :closed

    @path = '/api/opportunities'

    def initialize(json:, response:)
      json['links'].each do |link|
        @signup_href = link['href'] if link['rel'] == 'signup'
      end
      super(json: json, response: response)
    end

    def self.where(params)
      items_from_response(RestoreStrategies.client.search(params))
    end

    def self.featured(user_id: nil)
      path = if user_id
               "/api/admin/users/#{user_id}/opportunities"
             else
               '/api/opportunities/featured'
             end

      items_from_response(RestoreStrategies.client.list_items(path))
    end

    def self.feature(id:, user_id:)
      payload = { template: { data: [{ name: 'id', value: id }] } }.to_json

      begin
        RestoreStrategies.client.post_item(
          "/api/admin/users/#{user_id}/opportunities", payload
        )
        true
      rescue UnprocessableEntityError
        false
      end
    end

    def self.unfeature(id:, user_id:)
      res = RestoreStrategies.client.delete_item(
        "/api/admin/users/#{user_id}/opportunities",
        id
      )

      case res.response.code.to_i
      when 200, 202, 204
        true
      else
        false
      end
    end
  end
end
