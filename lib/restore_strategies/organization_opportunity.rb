# frozen_string_literal: true

module RestoreStrategies
  # The objectification of an opportunity that belongs to an organization
  class OrganizationOpportunity < ApiCollectable
    include RestoreStrategies::Updateable

    validates :name, :regions, :times, :coordinator, :ongoing, :location,
              :status, :days, :level, :description, :issues, :type,
              :organization_sfid, :organization_id, :group_types,
              :municipalities, presence: true

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)

        if @coordinator
          @coordinator = RestoreStrategies::Person.new(
            json: @coordinator,
            response: response
          )
        end
      else
        self.instance_vars = data
        @path = "/api/admin/organizations/#{data[:organization_id]}" \
                '/opportunities'

        @new_object = if !data[:new_object].nil?
                        data[:new_object]
                      else
                        true
                      end
      end

      field_attr :id, :name, :type, :closed, :description, :location,
                 :items_committed, :items_given, :max_items_needed, :ongoing,
                 :instructions, :gift_question, :level, :days, :times,
                 :group_types, :issues, :regions, :municipalities, :supplies,
                 :cities, :coordinator # check that this works, recursively
    end

    def create_path
      "/api/admin/organizations/#{organization_id}/opportunities"
    end

    def update_path
      "/api/admin/organizations/#{organization_id}/opportunities/#{id}"
    end
  end
end