# frozen_string_literal: true

module RestoreStrategies
  # A collection of signup objects
  class SignupCollection < Collection
    def initialize(collection = nil, user_id = nil)
      super(Signup.new(user_id: user_id), collection)
    end
  end
end
