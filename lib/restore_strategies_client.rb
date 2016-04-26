require 'restore_strategies_client/version'
require 'json'
require 'hawk'
require 'cgi'

module RestoreStrategiesClient
  # Restore Strategies client
  class Client
    def initialize(token, secret, host = nil, port = nil)
      @token = token
      @secret = secret
      @host = host
      @port = port

      @credentials = {
        id: @token,
        key: @secret,
        algorithm: 'sha256'
      }
    end

    def api_request(path, verb, data = nil)
      verb.downcase!

      auth = Hawk::Client.build_authorization_header(
        credentials: @credentials,
        ts: Time.now,
        method: verb,
        request_uri: path,
        host: @host,
        port: @port,
        payload: data,
        nonce: SecureRandom.uuid[0..5]
      )

      header = {
        'Content-type' => 'application/vnd.collection+json',
        'api-version' => '1',
        'Authorization' => auth
      }

      http = Net::HTTP.new(@host, @port)

      response = if verb == 'post'
                   http.post(path, data, header)
                 else
                   http.get(path, header)
                 end
      response
    end

    def get_opportunity(id)
      path = '/api/opportunities/' + id.to_s
      api_request(path, 'GET')
    end

    def list_opportunities
      href = '/api/opportunities'
      api_request(href, 'GET')
    end

    def search(params)
      href = '/api/search?' + params_to_string(params)
      api_request(href, 'GET')
    end

    def get_signup(id)
      href = '/api/opportunities/' + id.to_s + '/signup'
      api_request(href, 'GET')
    end

    def submit_signup(id, template)
      data = []
      json_str = '{ "template": { "data": ['

      template.each do |key, value|
        data.push(build_element(key, value))
      end

      json_str += data.join(', ') + '] } }'
      href = '/api/opportunities/' + id.to_s + '/signup'

      api_request(href, 'POST', json_str)
    end

    def build_element(key, value)
      if key == 'numOfItemsCommitted'
        '{ "name": "' + key + '", "value": ' + value.to_s + ' }'
      else
        '{ "name": "' + key + '", "value": "' + value + '" }'
      end
    end

    def params_to_string(params)
      query = []
      return nil unless params.is_a? Hash

      params.each do |key, value|
        if (value.is_a? Hash) || (value.is_a? Array)
          value.each { |sub_val| query.push(key + '[]=' + CGI.escape(sub_val)) }
        else
          query.push(key + '=' + CGI.escape(value))
        end
      end

      query.join('&')
    end
  end
end
