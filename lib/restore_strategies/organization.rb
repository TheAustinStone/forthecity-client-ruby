# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's organization
  class Organization < ApiObject
    extend RestoreStrategies::Collectable
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

    def self.blacklist
      OrganizationCollection.new(
        items_from_response(
          RestoreStrategies.client.list_items("#{@path}/blacklist")
        )
      )
    end

    private_class_method :collection_vars, :new_collection

    def self.collection_vars(id)
      @path = "/api/admin/users/#{id}/organizations"
    end

    def self.new_collection
      OrganizationCollection.new
    end
  end
end
