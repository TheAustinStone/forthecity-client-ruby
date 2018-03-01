# frozen_string_literal: true

module RestoreStrategies
  # Objectification of the API's key
  class Key < ApiObject
    include RestoreStrategies::POSTing

    attr_accessor :active, :description, :secret, :token, :city, :church,
                  :user_id, :domain

    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
        @path = "/api/admin/users/#{data[:user_id]}/keys"
      end
      field_attr :active, :description, :domain
    end

    def self.collection(id)
      @user_id = id
      @path = "/api/admin/users/#{id}/keys"
      @collection ||= KeyCollection.new
    end

    def self.create(**data)
      data[:user_id] = @user_id
      obj = new(data)
      obj.save_and_check
    end

    def save
      @response = RestoreStrategies.client.post_item(@path, to_payload)
      code = @response.response.code

      if %w[201 200].include? code
        vars_from_response
        true
      else
        false
      end
    end
  end
end
