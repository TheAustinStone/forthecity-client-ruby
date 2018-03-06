# frozen_string_literal: true

module RestoreStrategies
  # Provides methods for extending classes that have collections.
  module Collectable
    # Create or retrieve collection
    def collection(id)
      collection_vars(id)
      @collection ||= new_collection
    end

    # Add item to collection
    def add(item)
      RestoreStrategies.client.post_item(@path, item.to_payload)
    end

    # Remove item from collection
    def remove(item)
      RestoreStrategies.client.delete_item(@path, item.id)
    end

    private

    # Sets collection variables
    #
    # Override
    def collection_vars(id)
      @path = nil
      @user_id = id
    end

    # Creates a new collection
    #
    # Override
    def new_collection
      Collection.new
    end
  end
end
