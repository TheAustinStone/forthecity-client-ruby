# frozen_string_literal: true

module RestoreStrategies
  # A collection of customer signup objects
  class CustomerSignupCollection < Collection
    def initialize(collection = nil, user_id = nil)
      super(CustomerSignup.new(user_id: user_id), collection)
    end
  end
end
