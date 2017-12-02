# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's organization
  class Organization < ApiObject
    include RestoreStrategies::POSTing

    attr_reader :id, :name, :website, :description

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
      end
      field_attr :id, :name, :website, :description
    end

    def self.collection(id)
      @path = "/api/admin/users/#{id}/organizations"
      @collection ||= OrganizationCollection.new
    end

    def self.blacklist
      OrganizationCollection.new(
        items_from_response(
          RestoreStrategies.client.list_items("#{@path}/blacklist")
        )
      )
    end

    def self.remove(org)
      RestoreStrategies.client.delete_item(@path, org.id)
    end

    def self.add(org)
      RestoreStrategies.client.post_item(@path, org.to_payload)
    end
  end
end
