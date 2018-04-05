# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's organization
  class Organization < ApiCollectable
    include RestoreStrategies::POSTing

    attr_reader :id, :name, :website, :description

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
        @path = "/api/admin/users/#{data[:user_id]}/organizations"
      end
      field_attr :id, :name, :website, :description
    end

    def blacklist
      OrganizationCollection.new(
        items_from_response(
          RestoreStrategies.client.list_items("#{@path}/blacklist")
        ),
        @user_id
      )
    end
  end
end
