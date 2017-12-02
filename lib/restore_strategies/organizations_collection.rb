# frozen_string_literal: true

module RestoreStrategies
  # A collection of organization objects
  class OrganizationCollection < Collection
    def initialize(collection = nil)
      super(Organization, collection)
    end
  end
end
