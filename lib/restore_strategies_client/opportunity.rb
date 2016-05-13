module RestoreStrategiesClient
  class Opportunity

    attr_reader :raw, :client

    def initialize(json_obj, json_str, client)
      @raw = json_str
      @client = client

      json_obj["data"].each do |datum|
        name = datum["name"]
        value = datum["value"]
        instance_variable_set("@#{name}", value)
      end

      json_obj["links"].each do |link|
        @signup_href = if link["rel"] == "signup" then link["href"] end
      end
    end

    def get_signup
      #:client.get_signup self.id
      #signup_obj = JSON.parse(signup_str)
      #Signup.new(signup_obj, signup_str, self, :client)
    end

    def submit_signup(signup)
      #raise TypeError unlcess signup.is_a? Signup
      #raise SignupValidationError,
      #  'Signup does not contain valid data' unless signup.valid?
      #:client.submit_signup self.id, signup.to_payload
    end
  end
end
