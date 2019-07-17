# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's user
  class User < ApiObject
    include RestoreStrategies::Updateable

    attr_accessor :given_name, :family_name, :church, :church_size,
                  :franchise_city, :website, :street_address, :address_locality,
                  :address_region, :postal_code, :email, :uuid,
                  :subscription_id, :plan_id, :addon_id, :plan_level,
                  :created_at, :updated_at, :telephone, :reseller_id,
                  :auto_approve_orgs, :cities

    @path = '/api/admin/users'
    validates :given_name, :family_name, :church, :website, :street_address,
              :address_locality, :address_region, :postal_code, presence: true
    validates :email, email: true

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

      field_attr  :given_name, :family_name, :church, :church_size,
                  :franchise_city, :website, :street_address, :address_locality,
                  :address_region, :postal_code, :email, :uuid, :telephone,
                  :subscription_id, :plan_id, :addon_id, :plan_level,
                  :reseller_id, :auto_approve_orgs, :cities
    end

    def create_path
      '/api/admin/users'
    end

    def update_path
      "/api/admin/users/#{id}"
    end

    def keys
      @keys ||= RestoreStrategies::KeyCollection.new(nil, id)
    end

    def signups
      @signups ||= RestoreStrategies::SignupCollection.new(nil, id)
    end

    def organizations
      @orgs ||= RestoreStrategies::OrganizationCollection.new(nil, id)
    end

    def customers
      @customers ||= RestoreStrategies::Customer.new(id)
    end

    def opportunities
      @opportunities ||=
        RestoreStrategies::OrganizationOpportunityCollection.new(
          nil, organization_id
        )
    end
  end
end
