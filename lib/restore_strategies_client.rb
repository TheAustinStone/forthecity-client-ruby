require 'restore_strategies_client/version'
require 'json'
require 'hawk'
require 'cgi'
require 'uri'
require 'restore_strategies_client/opportunities'
require 'webmock'
include WebMock::API
WebMock.enable!

module RestoreStrategiesClient

  class RSError < StandardError
  end

  class ResponseError < RSError
    attr_reader :response
    def initialize(response, message = nil)
      message = message or 'Response error with the following code: ' + response.code
      @response = response
      super(message)
    end
  end

  class Response
    attr_reader :response, :data
    def  initialize(response, data = nil)
      @data = data
      @response = response
    end
  end

  # Restore Strategies client
  class Client

    attr_reader :opportunities
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

      @opportunities = Opportunities.new(self)
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

      unless (response.code == '200' || response.code == '201' || response.code == '202' || response.code == '451') then
        raise ResponseError.new(response)
      end

      Response.new(response, response.body)
    end

    def get_opportunity(id)
      params = {'id' => id}
      response = search(params)
      json_obj = JSON.parse(response.data)
      opp = json_obj['collection']['items'][0]
      if opp.nil?
        href = json_obj['collection']['href']
        WebMock::API::stub_request(:get, @host + href).to_return(:status => 404, :body => response.data)
        http = Net::HTTP.new(@host)
        response = http.get(href)
        raise ResponseError.new(response)
      end
      response
    end

    def list_opportunities
      request = get_entry.data
      json_obj = JSON.parse(request)['collection']['links']
      href = get_rel_href('opportunities', json_obj)
      api_request(href, 'GET')
    end

    def search(params)
      params_str = self.class.params_to_string(params)
      request = get_entry.data
      json_obj = JSON.parse(request)['collection']['links']
      href = get_rel_href('search', json_obj) + '?' + params_str
      api_request(href, 'GET')
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

    def get_entry
      api_request(self.entry_point, 'GET')
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

            query.push(key + '[]=' +
              ((sub_value.is_a? Numeric)? sub_value.to_s : CGI.escape(sub_value)))
          end
        else
          query.push(key + '=' +
            ((value.is_a? Numeric)? value.to_s : CGI.escape(value)))
        end
      end

      query = query.join('&')
      query
    end

    def get_rel_href(rel, json_obj)

      if json_obj.is_a? Array then
        json_obj.each do |data|
          href = get_rel_href_helper(rel, data)
          return href if !href.nil?
        end
      else
        return get_rel_href_helper(rel, json_obj)
      end

      return nil
    end

    def get_rel_href_helper(rel, json_obj)

      if json_obj['rel'] == rel then
        return json_obj['href']
      end

      return nil
    end

    def build_mock_response(code, message)
      Net::HTTP.stub!(:post_form).and_return()
    end
  end
end
