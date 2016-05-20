module RestoreStrategies
  # Restore Strategies client
  class Client
    attr_reader :entry_point

    def initialize(token, secret, host = nil, port = nil)
      @entry_point = '/api'
      @token = token
      @secret = secret
      @host = host
      @port = port

      @credentials = {
        id: @token,
        key: @secret,
        algorithm: 'sha256'
      }

      RestoreStrategies.client = self
    end

    def api_request(path, verb, payload = nil)
      verb.downcase!

      auth = Hawk::Client.build_authorization_header(
        credentials: @credentials,
        ts: Time.now,
        method: verb,
        request_uri: path,
        host: @host,
        port: @port,
        payload: payload,
        nonce: SecureRandom.uuid[0..5]
      )

      header = {
        'Content-type' => 'application/vnd.collection+json',
        'api-version' => '1',
        'Authorization' => auth
      }

      http = Net::HTTP.new(@host, @port)

      response = if verb == 'post'
                   http.post(path, payload, header)
                 else
                   http.get(path, header)
                 end

      code = response.code

      case code
      when '500'
        # internal server error
        raise InternalServerError.new(response), '500 internal server error'
      when /^5/
        # 5xx server side error
        raise ServerError.new(response), '5xx level, server side error'
      when '400'
        # bad request
        raise RequestError.new(response), '400 error, bad request'
      when '401'
        # unauthorized
        raise UnauthorizedError.new(response), '401 error, unauthorized'
      when '403'
        # forbidden
        raise ForbiddenError.new(response), '403 error, forbidden'
      when '404'
        # not found
        # pass thru 404 errors so the caller can handle them
        Response.new(response, response.body)
      when /^4/
        # 4xx client side error
        raise ClientError.new(response, "client side #{code} error"),
              "client side #{code} error"
      else
        Response.new(response, response.body)
      end
    end

    def get_opportunity(id)
      api_request("/api/opportunities/#{id}", 'GET')
    end

    def list_opportunities
      api_request('/api/opportunities', 'GET')
    end

    def search(params)
      params_str = self.class.params_to_string(params)
      api_request("/api/search?#{params_str}", 'GET')
    end

    def get_signup(id)
      href = get_signup_href(id)
      return nil if href.nil?
      api_request(href, 'GET')
    end

    def submit_signup(id, payload)
      href = get_signup_href(id)
      return nil if href.nil?
      api_request(href, 'POST', payload)
    end

    def get_signup_href(id)
      request = get_opportunity(id).data
      json_obj = JSON.parse(request)
      return nil if json_obj.nil?
      get_rel_href('signup', json_obj['collection']['items'][0]['links'])
    end

    def self.params_to_string(params)
      query = []
      return nil unless params.is_a? Hash

      params.each do |key, value|
        if (value.is_a? Hash) || (value.is_a? Array)
          value.each do |sub_value|
            value = if sub_value.is_a? Numeric
                      sub_value.to_s
                    else
                      CGI.escape(sub_value)
                    end

            query.push(key + '[]=' + value)
          end
        else
          query.push(key + '=' +
            ((value.is_a? Numeric) ? value.to_s : CGI.escape(value)))
        end
      end

      query.join('&')
    end

    def get_rel_href(rel, json_obj)
      return get_rel_href_helper(rel, json_obj) unless json_obj.is_a? Array

      json_obj.each do |data|
        href = get_rel_href_helper(rel, data)
        return href unless href.nil?
      end

      nil
    end

    def get_rel_href_helper(rel, json_obj)
      return json_obj['href'] if json_obj['rel'] == rel
      nil
    end
  end
end
