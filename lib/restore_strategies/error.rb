module RestoreStrategies
  # General response error class
  class ResponseError < StandardError
    attr_reader :response
    def initialize(response, message = nil)
      message ||= 'Response error with the following code: ' + response.code

      @response = response
      super(message)
    end
  end

  # For HTTP 500 errors
  class InternalServerError < ResponseError
    def initialize(response)
      super(response, message)
    end
  end

  # For HTTP 5xx errors
  class ServerError < ResponseError
    def initialize(response)
      message = 'Server error'
      super(response, message)
    end
  end

  # For HTTP 400 errors
  class RequestError < ResponseError
    def initialize(response)
      message = 'Bad request'
      super(response, message)
    end
  end

  # For HTTP 401 errors
  class UnauthorizedError < ResponseError
    def initialize(response)
      message = 'Unauthorized to access this resource'
      super(response, message)
    end
  end

  # For HTTP 403 errors
  class ForbiddenError < ResponseError
    def initialize(response)
      message = 'This resource is forbidden'
      super(response, message)
    end
  end

  # For HTTP 404 errors
  class NotFoundError < ResponseError
  end

  # For HTTP 4xx errors
  class ClientError < ResponseError
  end
end
