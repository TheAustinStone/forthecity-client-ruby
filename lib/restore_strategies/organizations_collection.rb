# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's organization
  class OrganizationCollection < Collection
    def initialize(collection = nil)
      super(Organization, collection)
    end
  end
end
