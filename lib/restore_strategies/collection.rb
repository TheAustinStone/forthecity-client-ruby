# frozen_string_literal: true

module RestoreStrategies
  # Holds a collection of klass objects
  #
  # The klass is expected to provide the following methods:
  #
  # - *all* returns an array of klass objects. This is required.
  # - *add* adds an item to the collection
  # - *remove* removes an item from the collection.
  #
  # The collection is lazy loaded & saved. So it won't be requested multiple
  # times from the server unless an action that alters it is performed.
  #
  # Collection searches klass for missing methods before sending to super. So
  # klass can be populated with various methods that can be used to chain.
  class Collection
    include Enumerable

    def initialize(klass, collection = nil)
      @klass = klass
      @collection = collection
    end

    def each(&block)
      collection.each(&block)
    end

    def length
      count
    end

    def blank?
      count.zero?
    end

    def refresh_collection
      @collection = @klass.all
      self
    end

    def [](key)
      collection[key]
    end

    def <<(*items)
      items.each { |item| @klass.add(item) }
      @collection = @klass.all
      self
    end

    def delete(*items)
      items.each { |item| @klass.remove(item) }
      @collection = @klass.all
      self
    end

    def where(**data)
      cmds = []

      data.each do |key, value|
        val = if value.class == String
                "'#{value}'"
              else
                value
              end
        cmds.push("i.#{key} == #{val}")
      end

      collection.find_all { |i| eval(cmds.join(' && ')) }
    end

    private

    def collection
      @collection ||= @klass.all
    end

    def method_missing(method, *args, &block)
      if @klass.respond_to? method
        @klass.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method)
      @klass.respond_to?(method) || super
    end
  end
end
