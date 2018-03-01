# frozen_string_literal: true

module RestoreStrategies
  # A collection of key objects
  class KeyCollection < Collection
    def initialize(collection = nil)
      super(Key, collection)
    end
  end
end
