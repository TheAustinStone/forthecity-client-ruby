# frozen_string_literal: true

module RestoreStrategies
  # A module for API objects that can be created and also updated
  #
  # Expects the including class to have *create_path* and *update_path* methods
  # which provide the proper API endpoint to create and update the object
  module Updateable
    include RestoreStrategies::POSTing

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def create(**data)
        obj = new(data)
        obj.save_and_check
      end
    end

    def save
      return false unless valid?

      path = new_object? ? create_path : update_path
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
  end
end
