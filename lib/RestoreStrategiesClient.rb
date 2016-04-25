require "RestoreStrategiesClient/version"
require "json"
require "hawk"
require "cgi"

module RestoreStrategiesClient
  class Client
      def initialize(token, secret, host = nil, port = nil)
        @token = token
        @secret = secret
        @host = host
        @port = port
        @credentials = {
            :id => @token,
            :key => @secret,
            :algorithm => 'sha256'
          }
      end

      def api_request(path, verb, data = nil)
        #uri = @host path
        verb.downcase!
        auth = Hawk::Client.build_authorization_header(
          :credentials => @credentials,
          :ts => Time.now,
          :method => verb,
          :request_uri => path,
          :host => @host,
          :port => @port,
          :payload => data,
          :nonce => SecureRandom.uuid[0..5]
        )
        header = {
          'Content-type' => 'application/vnd.collection+json',
          'api-version' => '1',
          'Authorization' => auth
        }
        http = Net::HTTP.new(@host, @port)
        response = if verb == 'post' then
          http.post(path, data, header)
        else
          http.get(path, header)
        end
        response
      end

      def get_opportunity(id)
        path = '/api/opportunities/' + id.to_s
        response = api_request(path, 'GET')
      end

      def list_opportunities()
        href = '/api/opportunities'
        response = api_request(href, 'GET')
      end

      def search(params)
        href = '/api/search?' + params_to_string(params)
        response = api_request(href, 'GET')
      end

      def get_signup(id)
        href = '/api/opportunities/' + id.to_s + '/signup'
        response = api_request(href, 'GET')
      end

      def submit_signup(id, template)
        data = []
        json_str = '{ "template": { "data": ['

        template.each do |key, value|
          if key == 'numOfItemsCommitted' then
            element = '{ "name": "' + key + '", "value": ' + value.to_s + ' }'
          else
            element = '{ "name": "' + key + '", "value": "' + value + '" }'
          end
          data.push(element)
        end

        json_str += data.join(', ') + '] } }'
        href = '/api/opportunities/' + id.to_s + '/signup'
        response = api_request(href, 'POST', json_str)
      end

      def params_to_string(params)
        query = []
        unless params.kind_of?(Hash)
          return nil
        end

        params.each do |key, value|
          if value.kind_of?(Hash) || value.kind_of?(Array) then
            value.each do |sub_val|
              query.push(key + '[]=' + CGI.escape(sub_val))
            end
          else
            query.push(key + '=' + CGI.escape(value))
          end
        end

        query = query.join('&')
        query
      end
  end
end
