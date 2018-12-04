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

    def first
      collection[0]
    end

    def last
      collection[collection.count - 1]
    end

    def blank?
      count.zero?
    end

    def refresh!
      @collection = @klass.all
      self
    end

    def [](key)
      collection[key]
    end

    def <<(*items)
      items.each { |item| @klass.add(item) }
      refresh!
    end

    def delete(*items)
      items.each { |item| @klass.remove(item) }
      refresh!
    end

    #
    # where(
    #   'created_at > ? and created_at <= ? AND campus == ?',
    #   Date.today - 5,
    #   Date.today,
    #   'North Campus'
    # )
    #
    # OR
    #
    # where(email: 'example@example.com', campus: 'Test Campus')
    def where(*str_opts, **hash_opts)
      cmds = transform_arguments(str_opts, hash_opts)

      cmds.each_index { |i| cmds[i] = 'i.' + cmds[i] }

      collection.find_all { |i| eval(cmds.join(' && ')) }
    end

    private

    def transform_arguments(str_opts, hash_opts)
      return transform_strings(str_opts) if str_opts.count.positive?
      transform_hash(hash_opts)
    end

    def transform_hash(hash_opts)
      transformed = []

      hash_opts.each do |key, value|
        val = if value.class == String
                "'#{value}'"
              else
                value
              end
        transformed.push("#{key} == #{val}")
      end

      transformed
    end

    def transform_strings(str_opts)
      unless str_opts[0].class == String
        raise(ArgumentError, 'String expected as first argument')
      end

      statements = str_opts.delete_at(0).strip.split(/[\s]+and[\s]+/i)

      errmsg = "Wrong number of arguments: #{statements.count} provided, " \
               "#{str_opts.count} expected"

      raise(ArgumentError, errmsg) unless statements.count == str_opts.count

      statements.each_index do |i|
        if str_opts[i].class == String
          statements[i].gsub!('?', "'#{str_opts[i]}'")
        else
          statements[i].gsub!('?', str_opts[i].to_s)
        end
      end

      statements
    end

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
