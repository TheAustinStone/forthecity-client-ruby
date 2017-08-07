# frozen_string_literal: true

module RestoreStrategies
  # HTTP response
  class Response
    attr_reader :response, :data
    def initialize(response, data = nil)
      @data = data
      @response = response
    end
  end
end
