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

      collection.find_all do |i|
        bools = []
        cmds.each do |cmd|
          bools.push(compare(i, cmd))
        end
        bools.all?
      end
    end

    private

    def compare(object, opts)
      val = object.public_send(opts[:key].to_sym)
      val.public_send(opts[:operand], opts[:value])
    end

    # Returns an array of key, operand & value hashes. The key can be compared
    # to the value using the operand.
    #
    # e.g.
    # [
    #   { key: 'created_at', operand: '>', value: Time.now },
    #   { key: 'email', operand: '==', value: 'jon.doe@example.com' }
    # ]
    def transform_arguments(str_opts, hash_opts)
      return transform_strings(str_opts) if str_opts.count.positive?
      transform_hash(hash_opts)
    end

    # e.g.
    # transform_hash({ email: 'jon.doe@example.com', items_committed: '1' })
    def transform_hash(hash_opts)
      transformed = []

      hash_opts.each do |key, value|
        transformed.push(key: key, operand: '==', value: value)
      end

      transformed
    end

    def transform_strings(str_opts)
      # e.g.
      #
      # [
      #   'created_at_date < ? and email == ?',
      #   Date.today,
      #   'jon.doe@example.com'
      # ]

      unless str_opts[0].class == String
        raise(ArgumentError, 'String expected as first argument')
      end

      statements = str_opts.delete_at(0).strip.split(/[\s]+and[\s]+/i)

      unless statements.count == str_opts.count
        errmsg = "Wrong number of arguments: #{statements.count} provided, " \
                 "#{str_opts.count} expected"

        raise(ArgumentError, errmsg) 
      end

      statements.each_index do |i|
        statements[i] = {
          key: /\A[\w]+/.match(statements[i].strip).to_s,
          operand: /[<=>]+/.match(statements[i].strip).to_s,
          value: str_opts[i]
        }
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
