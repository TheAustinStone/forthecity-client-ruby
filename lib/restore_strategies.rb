require_relative'restore_strategies/version'
require 'json'
require 'hawk'
require 'cgi'
require 'uri'
require_relative'restore_strategies/opportunities'
require 'webmock'
include WebMock::API
WebMock.enable!
WebMock.allow_net_connect!

# Restore Strategies module
module RestoreStrategies
  @client = nil

  def self.client=(client)
    @client = client
  end

  def self.client
    @client
  end

  class RSError < StandardError
  end

  # Response error class
  class ResponseError < RSError
    attr_reader :response
    def initialize(response, message = nil)
      message ||= 'Response error with the following code: ' + response.code

      @response = response
      super(message)
    end
  end

  # HTTP response
  class Response
    attr_reader :response, :data
    def initialize(response, data = nil)
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

      successful_response = code == '200' ||
                            code == '201' ||
                            code == '202' ||
                            code == '451'

      unless successful_response
        raise ResponseError.new(response), "Response error code #{code}"
      end

      Response.new(response, response.body)
    end

    def get_opportunity(id)
      params = { 'id' => id }
      response = search(params)
      json_obj = JSON.parse(response.data)
      opp = json_obj['collection']['items'][0]
      if opp.nil?
        href = json_obj['collection']['href']

        WebMock::API.stub_request(:get, @host + href)
                    .to_return(status: 404, body: response.data)

        http = Net::HTTP.new(@host)
        response = http.get(href)
        raise ResponseError.new(response), 'Opportunity not found'
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
      api_request(entry_point, 'GET')
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

    def build_mock_response
      Net::HTTP.stub!(:post_form).and_return
    end
  end
end
