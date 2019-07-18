# frozen_string_literal: true

require 'active_model'
require 'time'
require_relative 'error'

module RestoreStrategies
  # Generic class to manipulate API resources as Ruby classes
  class ApiObject
    include ActiveModel::Model

    attr_reader :response, :client, :id

    def initialize(json:, response:, new_object: false)
      @response = response.response
      @new_object = new_object

      json['data'].each do |datum|
        instance_variable_set("@#{datum['name'].underscore}", value_of(datum))
        self.class.send(:attr_reader, datum['name'].underscore.to_sym)
      end

      if @created_at
        @created_at_date = @created_at.to_date
        self.class.send(:attr_reader, :created_at_date)
      end

      return unless @updated_at
      @updated_at_date = @updated_at.to_date
      self.class.send(:attr_reader, :updated_at_date)
    end

    # For Rails API
    # http://api.rubyonrails.org/classes/ActiveModel/Model.html#method-i-persisted-3F
    def persisted?
      !new_object?
    end

    def new_object?
      @new_object
    end

    def response_data
      JSON.parse(@response.data)
    end
    private :response_data

    def value_of(datum)
      v = if !datum['value'].nil?
            datum['value']
          elsif !datum['array'].nil?
            datum['array']
          elsif !datum['object'].nil?
            datum['object']
          end

      return Time.parse(v) if %w[created_at updated_at].include?(datum['name'])

      v
    end
    private :value_of

    def instance_vars=(data)
      data.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_reader, key.to_sym)
      end
    end
    private :instance_vars=

    def vars_from_response
      response_data['collection']['items'][0]['data'].each do |datum|
        instance_variable_set("@#{datum['name'].underscore}", value_of(datum))
      end
    end
    private :vars_from_response

    def save_and_check
      if save
        self
      else
        false
      end
    end

    def self.find(id, path = nil)
      raise ArgumentError, 'id must be integer' unless id.is_a? Integer

      api_response = RestoreStrategies.client.get_item(url_path(path), id)

      case api_response.response.code.to_i
      when 200
        json = JSON.parse(api_response.data)['collection']['items'][0]
        new(json: json, response: api_response)
      when 404
        raise NotFoundError.new(api_response, "#{self} not found")
      end
    end

    def self.items_from_response(api_response)
      results = []
      items = JSON.parse(api_response.data)['collection']['items']

      return results if items.nil?

      items.each do |item|
        results.push(new(json: item, response: api_response))
      end

      results
    end

    def self.all(path = nil)
      items_from_response(RestoreStrategies.client.list_items(url_path(path)))
    end

    def self.first(path = nil)
      all(path).first
    end

    def self.url_path(path)
      path || @path
    end
  end
end
