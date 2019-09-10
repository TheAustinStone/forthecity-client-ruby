# frozen_string_literal: true

module RestoreStrategies
  # A collection of organization opportunity objects
  class OrganizationPeopleCollection < Collection
    def initialize(collection = nil, organization_id = nil)
      super(
        OrganizationPerson.new(organization_id: organization_id),
        collection
      )
    end
  end
end
