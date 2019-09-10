module RestoreStrategies
  # Objectification of the API's organization person
  #
  # This can be used standalone or as a coordinator in an organization's
  # opportunity
  class OrganizationPerson < ApiCollectable
    include RestoreStrategies::Updateable

    validates :given_name, :family_name, :email, :organization_id,
              presence: true

    attr_accessor :given_name, :family_name, :church, :email, :telephone,
                  :street_address, :address_locality, :address_region,
                  :postal_code, :organization_id

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data

        @new_object = if !data[:new_object].nil?
                        data[:new_object]
                      else
                        true
                      end
      end

      @path = "/api/admin/organizations/#{data[:organization_id]}" \
              '/people'

      field_attr :id, :uuid, :given_name, :family_name, :church, :email,
                 :telephone, :street_address, :address_locality,
                 :address_region, :postal_code
    end

    def create_path
      "/api/admin/organizations/#{organization_id}/people"
    end

    def update_path
      "/api/admin/organizations/#{organization_id}/people/#{id}"
    end
  end
end
