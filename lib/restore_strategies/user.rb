# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's user
  class User < ApiObject
    include RestoreStrategies::POSTing

    attr_accessor :given_name, :family_name, :church, :church_size,
                  :franchise_city, :website, :street_address, :address_locality,
                  :address_region, :postal_code, :email, :uuid,
                  :subscription_id, :plan_id, :addon_id, :plan_level,
                  :created_at, :updated_at

    @path = '/api/admin/users'
    validates :given_name, :family_name, :church, :church_size,
              :franchise_city, :website, :street_address, :address_locality,
              :address_region, :postal_code, presence: true
    validates :email, email: true

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
        @new_record = data[:new_object] || true
      end

      field_attr  :given_name, :family_name, :church, :church_size,
                  :franchise_city, :website, :street_address, :address_locality,
                  :address_region, :postal_code, :email, :uuid,
                  :subscription_id, :plan_id, :addon_id, :plan_level
    end

    def self.create(**data)
      obj = new(data)
      obj.save_and_check
    end

    def save
      return false unless valid?

      path = if new_record?
               '/api/admin/users'
             else
               "/api/admin/users/#{id}"
             end

      @response = RestoreStrategies.client.post_item(path, to_payload)
      code = @response.response.code

      if code == '201' || code == '200'
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

    def save_and_check
      if save
        self
      else
        false
      end
    end

    private

    # def destroy; end
  end
end
