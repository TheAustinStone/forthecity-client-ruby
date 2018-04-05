# frozen_string_literal: true

module RestoreStrategies
  # Generic class to manipulate API resources as Ruby classes
  class ApiCollectable < ApiObject
    attr_accessor :path

    # Add item to collection
    def add(item)
      RestoreStrategies.client.post_item(@path, item.to_payload)
    end

    # Remove item from collection
    def remove(item)
      RestoreStrategies.client.delete_item(@path, item.id)
    end

    def find(id)
      self.class.find(id, @path)
    end

    def items_from_response(api_response)
      self.class.items_from_response(api_response)
    end

    def all
      self.class.all(@path)
    end

    def first
      self.class.first(@path)
    end
  end
end
