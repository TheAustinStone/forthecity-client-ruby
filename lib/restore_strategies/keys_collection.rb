# frozen_string_literal: true

module RestoreStrategies
  # A collection of key objects
  class KeyCollection < Collection
    def initialize(collection = nil, user_id = nil)
      super(Key.new(user_id: user_id), collection)
    end
  end
end
