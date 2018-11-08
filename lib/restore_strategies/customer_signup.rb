# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's organization
  class CustomerSignup < ApiCollectable
    attr_reader :updated_at, :created_at, :opportunity_name, :organization_name,
                :issues, :level, :items_committed, :church, :api_user, :user_id,
                :reseller_id

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
        @path = "/api/admin/users/#{data[:user_id]}/customers/signups"
      end
    end
  end
end
