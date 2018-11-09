# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's organization
  class CustomerSignup < ApiCollectable
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
