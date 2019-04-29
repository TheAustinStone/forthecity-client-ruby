# frozen_string_literal: true

module RestoreStrategies
  # A collection of organization opportunity objects
  class OrganizationOpportunityCollection < Collection
    def initialize(collection = nil, organization_id = nil)
      super(
        OrganizationOpportunity.new(organization_id: organization_id),
        collection
      )
    end
  end
end
