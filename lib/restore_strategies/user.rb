# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's user
  class User < ApiObject
    include RestoreStrategies::POSTing

    attr_accessor :given_name, :family_name, :church, :church_size,
                  :franchise_city, :website, :street_address, :address_locality,
                  :address_region, :postal_code, :email, :uuid,
                  :subscription_id, :plan_id, :addon_id, :plan_level,
                  :created_at, :updated_at, :telephone, :reseller_id,
                  :auto_approve_orgs

    @path = '/api/admin/users'
    validates :given_name, :family_name, :church,:website, :street_address,
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
                  :reseller_id, :auto_approve_orgs
    end

    def self.create(**data)
      obj = new(data)
      obj.save_and_check
    end

    def save
      return false unless valid?

      path = if new_object?
               '/api/admin/users'
             else
               "/api/admin/users/#{id}"
             end

      @response = RestoreStrategies.client.post_item(path, to_payload)
      code = @response.response.code

      if %w[201 200].include? code
        @new_record = false
        vars_from_response
        true
      else
        false
      end
    end

    def save!
      save
    end

    def update(**data)
      self.instance_vars = data
      save_and_check
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
  end
end
