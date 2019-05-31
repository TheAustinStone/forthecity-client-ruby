module RestoreStrategies
  class Person < ApiObject
    def initialize(json: nil, response: nil, **data)
      if json && response
        super(json: json, response: response)
      else
        self.instance_vars = data
      end
    end
  end
end
