# frozen_string_literal: true

module RestoreStrategies
  # A collection of signup objects
  class SignupCollection < Collection
    def initialize(collection = nil)
      super(Signup, collection)
    end
  end
end
