# frozen_string_literal: true

module RestoreStrategies
  # A collection of organization objects
  class OrganizationCollection < Collection
    def initialize(collection = nil, user_id = nil)
      super(Organization.new(user_id: user_id), collection)
    end
  end
end
