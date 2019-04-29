# frozen_string_literal: true

require 'json'

module RestoreStrategies
  # Collection+JSON untilities
  class CollectionJson
    def self.build_template(postable)
      return nil unless postable.post_fields
      data = []

      postable.post_fields.each do |field|
        if postable.respond_to?(field) && !postable.send(field).nil?
          data.push(build_element(field.id2name, postable.send(field)))
        end
      end

      { 'template' => { 'data' => data } }
    end

    def self.build_element(key, value)
      if value.is_a? Array
        { 'name' => key.camelize(:lower), 'array' => value }
      elsif value.is_a? Hash
        { 'name' => key.camelize(:lower), 'object' => value }
      else
        { 'name' => key.camelize(:lower), 'value' => value }
      end
    end

    def self.parse_element(json)
      { json['name'].underscore => json['value'] }
    end
  end

  # Mixin for creating a POSTable representation of
  # data to the api
  module POSTing
    attr_reader :post_fields

    def field_attr(*args)
      @post_fields = []
      args.each do |arg|
        @post_fields.push arg
      end
    end

    def to_payload
      json_obj = CollectionJson.build_template(self)
      JSON.generate json_obj
    end
  end
end
