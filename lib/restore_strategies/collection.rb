# frozen_string_literal: true

module RestoreStrategies
  class Collection
    include Enumerable

    def initialize(klass, collection = nil)
      @klass = klass
      @collection = collection
    end

    def insure_collection
      @collection ||= @klass.all
    end

    def each(&block)
      insure_collection
      @collection.each(&block)
    end

    def count
      insure_collection
      @collection.length
    end

    def length
      insure_collection
      count
    end

    def [](key)
      insure_collection
      @collection[key]
    end

    def <<(*items)
      items.each { |item| @klass.add(item) }
      @collection = @klass.refresh_collection
      self
    end

    def delete(*items)
      items.each { |item| @klass.remove(item) }
      @collection = @klass.refresh_collection
      self
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
