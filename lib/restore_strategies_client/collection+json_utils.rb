require 'json'

module RestoreStrategiesClient
  class CollectionJson
    def self.build_template(postable)
      #return nil unless postable.post_fields
      #data = []

      #postable.post_fields.each do |field|
      #  data.push self.class.build_element(
      #    field.id2name.camelize(:lower),
      #    field
      #  )
      #end

      #json_obj = { 'template' => {'data' => data } }
    end

    def self.build_element(key, value)
      #{ 'name'=>key.underscore, 'value'=value }
    end

    def self.parse_element(json)
      #{ json['name'].camelize(:lower)=>json['value'] }
    end
  end

  # Mixin for creating a POSTable representation of
  # data to the api
  module POSTing
    def field_attr(*args)
      @post_fields = @post_fields or []
      args.each do |arg|
        post_fields.push arg
      end
    end

    def to_payload
      json_obj = CollectionJson.build_template(self)
      JSON.generate json_obj
    end
  end
end
