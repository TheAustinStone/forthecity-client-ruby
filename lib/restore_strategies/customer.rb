# frozen_string_literal: true

module RestoreStrategies
  # Reseller customer
  class Customer
    def initialize(id)
      @id = id
    end

    def signups
      @signups ||= RestoreStrategies::CustomerSignupCollection.new(nil, @id)
    end
  end
end
