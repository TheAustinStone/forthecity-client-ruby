require 'net/http'
require 'spec_helper'
require 'json'
require 'webmock'

describe RestoreStrategiesClient do
  let(:client) do
    RestoreStrategiesClient::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  before do
    WebMock.allow_net_connect!
  end

  it 'has a version number' do
    expect(RestoreStrategiesClient::VERSION).not_to be nil
  end

  describe 'get_opportunity' do
    it 'responds with 404 code and error when the opportunity doesnt exist' do

      begin
        response = client.get_opportunity(1_000_000).data
        fail
      rescue RestoreStrategiesClient::ResponseError => e
        expect(e.response.code).to eq('404')
      end
    end

    it 'responds with an opportunity' do
      response = client.get_opportunity(1)
      response = JSON.parse(response.data)
      href = response['collection']['items'][0]['href']
      expect(href).to eq('/api/opportunities/1')
    end
  end

  describe 'list_opportunities' do
    it 'responds with a list of opportunities' do
      response = client.list_opportunities
      response = JSON.parse(response.data)
      expect(response['collection']['href']).to eq('/api/opportunities')
      expect(response['collection']['version']).to eq('1.0')
      expect(response['collection']['items'].is_a?(Array)).to be true
    end
  end

  describe 'search' do
    it 'responds with opportunities based on text search' do
      params = {
        'q' => 'foster care'
      }

      response = client.search(params)
      response = JSON.parse(response.data)

      expect(response['collection']['href']).to eq('/api/search?q=foster+care')
      expect(response['collection']['version']).to eq('1.0')
      expect(response['collection']['items'].is_a?(Array)).to be true
    end

    it 'responds with opportunities based on search parameters' do
      params = {
        'issues' => %w(Education Children/Youth),
        'region' => %w(South Central)
      }

      path = '/api/search?issues[]=Education&issues[]=Children%2FYouth&' \
             'region[]=South&region[]=Central'

      response = client.search(params)
      response = JSON.parse(response.data)

      expect(response['collection']['href']).to eq(path)
      expect(response['collection']['version']).to eq('1.0')
      expect(response['collection']['items'].is_a?(Array)).to be true
    end

    it 'responds with opportunities based on text and search parameters' do
      params = {
        'q' => 'foster care',
        'issues' => %w(Education Children/Youth),
        'region' => %w(South Central)
      }

      path = '/api/search?q=foster+care&issues[]=Education&' \
             'issues[]=Children%2FYouth&region[]=South&region[]=Central'

      response = client.search(params)
      response = JSON.parse(response.data)

      expect(response['collection']['href']).to eq(path)
      expect(response['collection']['version']).to eq('1.0')
      expect(response['collection']['items'].is_a?(Array)).to be true
    end
  end

  describe 'get_signup' do
    it 'responds with a signup template' do
      response = client.get_signup(1)
      response = JSON.parse(response.data)

      expect(response['collection']['version']).to eq('1.0')
      expect(response['collection']['template']['data'].is_a?(Array)).to be true
    end
  end

  describe 'submit_signup' do
    it 'responds with a 400 code from a bad signup template' do
      payload = {
        'template' => {
          'data' => [
            { 'name' => 'familyName', 'value' => 'Doe' },
            { 'name' => 'telephone', 'value' => '5124567890' },
            { 'name' => 'email', 'value' => 'jon.doe@example.com' },
            { 'name' => 'comment', 'value' => 'I\'m excited!' },
            { 'name' => 'numOfItemsCommitted', 'value' => 1 },
            { 'name' => 'lead', 'value' => 'other' }
          ]
        }
      }

      payload = JSON.generate(payload)

      begin
        response = client.submit_signup(1, payload)
        fail
      rescue RestoreStrategiesClient::ResponseError => e
        expect(e.response.code).to eq('400')
      end
    end

    it 'responds with a 202 code if the signup is accepted' do
      payload = {
        'template' => {
          'data' => [
            { 'name' => 'givenName', 'value' => 'Jon' },
            { 'name' => 'familyName', 'value' => 'Doe' },
            { 'name' => 'telephone', 'value' => '5124567890' },
            { 'name' => 'email', 'value' => 'jon.doe@example.com' },
            { 'name' => 'comment', 'value' => 'I\'m excited!' },
            { 'name' => 'numOfItemsCommitted', 'value' => 1 },
            { 'name' => 'lead', 'value' => 'other' }
          ]
        }
      }

      payload = JSON.generate(payload)
      response = client.submit_signup(1, payload)
      expect(response.response.code).to eq('202')
    end
  end
end
